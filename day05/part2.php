<?php

function print_range_array($ranges){
    echo "ranges are:\n";
    foreach($ranges as &$range){
        $range->print();
        echo "\n";
    }
}

function compute_diff($range_arr,$range_to_remove){
    $res = array();
    foreach($range_arr as &$range){
        if($range->does_intersect($range_to_remove)){
            $inter = $range->intersect($range_to_remove);
            if($inter->first() <= $range->first()){
                # left part not 
                if($inter->last() >= $range->last()){
                    # intersection = range
                }else{
                    # intersection only on the left
                    array_push($res,new range($inter->last(), $range->len() - $inter->len()));
                }
            }else{
                if($inter->last() >= $range->last()){
                    # intersectiononly on the right
                    array_push($res,new range($range->first(), $range->len() - $inter->len()));
                }else{
                    # both inside from left and right
                    array_push($res,new Range($range->first(),$inter->first()-$range->first()));
                    array_push($res,new Range($inter->last(),$range->last()-$inter->last()));
                }
            }
        }else{
            array_push($res,$range);
        }
    }
    return $res;
}

class Mapping{
    public $mappings;
    public $from_item;
    public $to_item;

    function add_mapping($mapping){
        array_push($this->mappings,$mapping);
    }

    function fill_blanks(){
        $residual = array(new Range(0,2147483640/2));
        foreach($this->mappings as &$map){
            $residual = compute_diff($residual,$map->source_range());
        }
        foreach($residual as &$single_res){
            $this->add_mapping(new SimpleMapping($single_res->first(),$single_res->first(),$single_res->len()));
        }
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

    function get_ranges($range){
        $res = array();
        foreach($this->mappings as &$mappa){
            if($mappa->does_intersect_source($range)){
                // echo "Intersezione esiste\n";
                // $mappa->source_range()->print();
                // $range->print();
                array_push($res, $mappa->get_intersection_image($range));
            }
        }
        return $res;
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

    function source_range(){
        return new Range($this->source_range_start,$this->range_length);
    }

    function does_intersect_source($range){
        return $this->source_range()->does_intersect($range);
    }

    function get_intersection_image($range){
        $intersect = $this->source_range()->intersect($range);
        return new Range($this->get_mapped($intersect->first()),$intersect->len());
    }

    function get_ranged_mapping($intersect_range){
        return new Range($this->dest_range_start,$intersect_range->len());
    }

    function source_start(){
        return $this->source_range_start;
    }

    function dest_start(){
        return $this->dest_range_start;
    }

    function len(){
        return $this->range_length;
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

    function get_to_type($from_type){
        foreach($this->all_maps as &$mappa){
            if($mappa->get_from() == $from_type){
                return $mappa->get_to();
            }
        }
        return "";
    }

    function get_ranges($range,$from_item){
        foreach($this->all_maps as &$mappa){
            if($mappa->get_from() == $from_item){
                return $mappa->get_ranges($range);
            }
        }
        return array();
    }
}

class Range{
    public $range_start;
    public $range_len;

    function __construct($start,$len){
        $this->range_start = $start;
        $this->range_len = $len;
    }

    function print(){
        echo "From: " . $this->range_start . " Len: " . $this->range_len . "\n";
    }

    function first(){
        return $this->range_start;
    }

    function last(){
        return $this->range_start + $this->range_len;
    }

    function len(){
        return $this->range_len;
    }

    function intersect($range){
        $intersect_min = max($this->first(),$range->first());
        $intersect_max = min($this->last(),$range->last());
        return new Range($intersect_min,$intersect_max-$intersect_min);
    }

    function does_intersect($range){
        $intersect_min = max($this->first(),$range->first());
        $intersect_max = min($this->last(),$range->last());
        return ($intersect_max - $intersect_min) > 0;
    }
}

class Seedrange{
    public $range_start;
    public $range_len;

    function __construct($start,$len){
        $this->range_start = $start;
        $this->range_len = $len;
    }

    function print(){
        echo "From: " . $this->range_start . "Len: " . $this->range_len . "\n";
    }

    function first(){
        return $this->range_start;
    }

    function last(){
        return $this->range_start + $this->range_len;
    }

    function walk($mapping_array){
        $current_item = "seed";
        $ranges = array(new Range($this->range_start,$this->range_len));
        $other_ranges = array();
        $flip = 0;
        while($current_item != "location"){
            if($flip == 0){
                $flip = 1;
                # ranges is input, other_ranges is output
                $other_ranges = array();
                foreach($ranges as &$r){
                    $res = $mapping_array->get_ranges($r,$current_item);
                    foreach($res as &$result){
                        array_push($other_ranges,$result);
                    }
                }
                // echo "from: " . $current_item;
                // print_range_array($other_ranges);
            }else{
                $flip = 0;
                # other_ranges is input, ranges is output
                $ranges = array();
                foreach($other_ranges as &$r){
                    $res = $mapping_array->get_ranges($r,$current_item);
                    foreach($res as &$result){
                        array_push($ranges,$result);
                    }
                }
                // echo "from: " . $current_item;
                // print_range_array($ranges);
            }
            $current_item = $mapping_array->get_to_type($current_item);
        }
        $min_loc = -1;
        if($flip = 0){
            # ranges is output
            foreach($ranges as &$r){
                if($min_loc == -1 || $min_loc > $r->first()){
                    $min_loc = $r->first();
                }
            }
        }else{
            # other_ranges is output
            foreach($other_ranges as &$r){
                if($min_loc == -1 || $min_loc > $r->first()){
                    $min_loc = $r->first();
                }
            }
        }
        return $min_loc;
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
        for ($x = 1; $x < $seed_len; $x+=2) {
            array_push($seeds,new Seedrange((int)$seed_ids[$x],(int)$seed_ids[$x+1]));
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
            $mapping_to_change = $mapping_array->get_last_map();
            $mapping_to_change->fill_blanks();
            continue;
        }
        $nums = explode(" ",$line);
        $mapping_to_change = $mapping_array->get_last_map();
        $mapping_to_change->add_mapping(new SimpleMapping((int)$nums[0],(int)$nums[1],(int)$nums[2]));
    }else{
        $status = 0;
    }
}
$mapping_to_change = $mapping_array->get_last_map();
$mapping_to_change->fill_blanks();

// $mapping_array->print();

$min_location = -1;
$count = 1;
foreach($seeds as &$range){
    // $range->print();
    // echo "Processing range " . $count . "\n";
    $count++;
    $loc = $range->walk($mapping_array);
    if($min_location == -1 || $loc < $min_location){
        $min_location = $loc;
    }
}

echo "Best location is: " . $min_location . "\n";

?>