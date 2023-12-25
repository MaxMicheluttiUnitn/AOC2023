class MirroredView{
    private contents = [];
    private int height;
    private int width;

    public MirroredView(String descriptor){
        String[] lines = descriptor.split("\n");
        this.width = lines[0].length();
        this.height = 0;
        for(String line: lines){
            this.height++;
            def line_array = [];
            for(int i=0;i<this.width;i++){
                if(line[i]=='#'){
                    line_array << 1;
                }else{
                    line_array << 2;
                }
            }
            this.contents << line_array;
        }
    }

    public void printClass(){
        for(int i=0;i<this.height;i++){
            for(int j=0;j<this.width;j++){
                print(this.contents[i][j]);
            }
            println("");
        }
    }

    private boolean sameRow(int id1,int id2){
        for(int j=0; j<this.width; j++){
            if(this.contents[id1][j]!=this.contents[id2][j]){
                return false;
            }
        }
        return true;
    }

    private int rowDifference(int id1,int id2){
        int diff=0;
        for(int j=0; j<this.width; j++){
            if(this.contents[id1][j]!=this.contents[id2][j]){
                diff++;
            }
        }
        return diff;
    }

    public int findSymmetricRow(){
        for(int axes=1;axes<this.height;axes++){
            boolean symmetric = true;
            for(int diff=0; axes-diff-1>=0 && axes+diff<this.height; diff++){
                if(!this.sameRow(axes+diff,axes-diff-1)){
                    symmetric = false;
                    break;
                }
            }
            if(symmetric){
                return axes;
            }
        }
        return 0;
    }

    public int findSymmetricRowFixed(){
        for(int axes=1;axes<this.height;axes++){
            int axes_diff = 0;
            for(int diff=0; axes-diff-1>=0 && axes+diff<this.height; diff++){
                axes_diff+=this.rowDifference(axes+diff,axes-diff-1);
            }
            if(axes_diff==1){
                return axes;
            }
        }
        return 0;
    }

    private boolean sameColumn(int id1,int id2){
        for(int j=0; j<this.height; j++){
            if(this.contents[j][id1]!=this.contents[j][id2]){
                return false;
            }
        }
        return true;
    }

    private int columnDifference(int id1,int id2){
        int diff=0;
        for(int j=0; j<this.height; j++){
            if(this.contents[j][id1]!=this.contents[j][id2]){
                diff++;
            }
        }
        return diff;
    }

    public int findSymmetricColumn(){
        for(int axes=1;axes<this.width;axes++){
            boolean symmetric = true;
            for(int diff=0; axes-diff-1>=0 && axes+diff<this.width; diff++){
                if(!this.sameColumn(axes+diff,axes-diff-1)){
                    symmetric = false;
                    break;
                }
            }
            if(symmetric){
                return axes;
            }
        }
        return 0;     
    }

    public int findSymmetricColumnFixed(){
        for(int axes=1;axes<this.width;axes++){
            int axes_diff=0;
            for(int diff=0; axes-diff-1>=0 && axes+diff<this.width; diff++){
                axes_diff+=this.columnDifference(axes+diff,axes-diff-1);
            }
            if(axes_diff==1){
                return axes;
            }
        }
        return 0;     
    }
}
   