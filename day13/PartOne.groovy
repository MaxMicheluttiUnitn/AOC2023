class PartOne {
   static void main(String[] args) {
      // Using a simple println statement to print output to the console
      String fileContents = new File('problem.txt').text
      String[] view_descriptors = fileContents.split('\n\n');
      def mirrored_views = [];
      for(String view_descriptor:view_descriptors){
         mirrored_views << new MirroredView(view_descriptor);
      }
      int total_rows=0;
      int total_columns=0;
      for(MirroredView mv: mirrored_views){
         // mv.printClass();
         int row_axes = mv.findSymmetricRow();
         int column_axes = mv.findSymmetricColumn();
         total_rows += row_axes;
         total_columns += column_axes;
      }
      println(total_rows*100 + total_columns);
   }
}