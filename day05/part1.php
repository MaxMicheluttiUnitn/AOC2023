<?php

class Mapping{
    public $mappings;
    public $from_item;
    public $to_item;

    function add_mapping($mapping){
        array_push($this->mappings,$mapping);
    }

    function __construct($from,$to) {
        $this->from_item = $from;
        $this->to_item = $to;
        $this->mappings = array();
    }

    function get_mapped($source){
        foreach($this->mappings as &$map){
            $out = $map->get_mapped($source);
            if($out != -1)
                return $out;
        }
        return $source;
    }

    function get_from(){
        return $this->from_item;
    }

    function get_to(){
        return $this->to_item;
    }

    function print(){
        echo "From: " . $this->from_item . " To: " . $this->to_item . "\n";
        foreach($this->mappings as &$mappa){
            $mappa->print();
            echo "\n";
        }
        echo "\n";
    }
}

class SimpleMapping{
    public $dest_range_start;
    public $source_range_start;
    public $range_length;

    function get_mapped($from){
        if($from < $this->source_range_start)
            return -1;
        if($from >= $this->source_range_start + $this->range_length)
            return -1;
        return $this->dest_range_start + ($from - $this->source_range_start);
    }

    function __construct($dest_start,$source_start,$len) {
        $this->dest_range_start = $dest_start;
        $this->source_range_start = $source_start;
        $this->range_length = $len;
    }

    function print(){
        echo $this->dest_range_start . " " . $this->source_range_start . " " . $this->range_length;
    }
}

class MappingArray{
    public $all_maps;

    function __construct(){
        $this->all_maps = array();
    }

    function get_last_map(){
        $total_maps = count($this->all_maps);
        return $this->all_maps[$total_maps-1];
    }

    function append($item){
        array_push($this->all_maps,$item);
    }

    function print(){
        foreach($this->all_maps as &$mappa){
            $mappa->print();
        }
    }

    function get_result($from_type,$id){
        foreach($this->all_maps as &$mappa){
            if($mappa->get_from() == $from_type){
                return array($mappa->get_to(),$mappa->get_mapped($id));
            }
        }
        return array();
    }
}

$input = explode("\n",file_get_contents("problem.txt"));
$status = 2;
$mapping_array = new MappingArray();
$seeds = array();

foreach($input as &$line){
    // echo $line;
    // echo "\n";
    if($status == 2){
        $seed_ids = explode(" ",$line);
        $seed_len = count($seed_ids);
        for ($x = 1; $x < $seed_len; $x++) {
            array_push($seeds,(int)$seed_ids[$x]);
        } 
        $status = 3;
    }else if($status == 0){
        $items = explode("-to-",explode(" ",$line)[0]);
        $new_mapping = new Mapping($items[0],$items[1]);
        $mapping_array->append($new_mapping);
        $status = 1;
    }else if($status == 1){
        if($line == ""){
            $status = 0;
            continue;
        }
        $nums = explode(" ",$line);
        $mapping_to_change = $mapping_array->get_last_map();
        $mapping_to_change->add_mapping(new SimpleMapping((int)$nums[0],(int)$nums[1],(int)$nums[2]));
    }else{
        $status = 0;
    }
}

$min_location = -1;
foreach($seeds as &$seed){
    $last_item_type = "seed";
    $current_id = $seed;
    while($last_item_type != "location"){
        $res = $mapping_array->get_result($last_item_type,$current_id);
        $current_id = $res[1];
        $last_item_type = $res[0];
    }
    if($min_location == -1  || $min_location > $current_id){
        $min_location = $current_id;
    }
}

echo "Best location is: " . $min_location . "\n";

?>