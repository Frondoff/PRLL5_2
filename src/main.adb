with Ada.Text_IO; use Ada.Text_IO;

procedure Main is

   size: Integer := 50000;
   type my_arr is array(0..size-1) of Long_Integer;

   protected elements_summing is
      procedure add_elements(first_element: Long_Integer; second_element: Long_Integer);
      function get_elements_sum return Long_Integer;
   private
      elements_sum: Long_Integer := 0;
   end elements_summing;

   protected body elements_summing is

      procedure add_elements(first_element: Long_Integer; second_element: Long_Integer) is
      begin
         elements_sum := first_element + second_element;
      end;

      function get_elements_sum return Long_Integer is
      begin
         return elements_sum;
      end;
   end elements_summing;


   protected sum_resolver is
      procedure set_array(arr: my_arr);
      procedure find_part_sum(active_size: Integer; last_size: Integer);
      function get_sum return Long_Integer;
   private
      private_arr: my_arr;
   end sum_resolver;

protected body sum_resolver is

      procedure set_array(arr: my_arr) is
      begin
         private_arr := arr;
      end;

      procedure find_part_sum(active_size: Integer; last_size: Integer) is
      begin
         for i in 0..active_size-1 loop
            if i /= last_size - i - 1 then
               elements_summing.add_elements(private_arr(i), private_arr(last_size - i - 1));

               private_arr(i) := elements_summing.get_elements_sum;
               private_arr(last_size - i - 1) := 0;
            end if;
         end loop;
      end;

      function get_sum return Long_Integer is
      begin
         return private_arr(0);
      end;

   end sum_resolver;


   active_size: Integer := size;
   last_size: Integer := size;
   arr: my_arr;
begin

   for i in 0..size-1 loop
      arr(i) := long_integer(i);
   end loop;

   sum_resolver.set_array(arr);

   while active_size > 1 loop
      if active_size rem 2 = 0 then
         active_size := active_size / 2;
      else
         active_size := active_size / 2 + 1;
      end if;

      sum_resolver.find_part_sum(active_size, last_size);

      last_size := active_size;
   end loop;

   Put_Line(sum_resolver.get_sum'Img);
end Main;


