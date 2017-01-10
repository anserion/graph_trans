//Copyright 2017 Andrey S. Ionisyan (anserion@gmail.com)
//
//Licensed under the Apache License, Version 2.0 (the "License");
//you may not use this file except in compliance with the License.
//You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//Unless required by applicable law or agreed to in writing, software
//distributed under the License is distributed on an "AS IS" BASIS,
//WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//See the License for the specific language governing permissions and
//limitations under the License.

//учебный шаблон перевода интерпретации графа из списка ребер
//в список смежности, матрицу смежности, матрицу инцидентности.

program graph_trans_edges;
const
   max_p=100;
   max_q=100;

var i,j,k,p,q,p_start,p_end:integer;
   graph_adj: array [1..max_p,1..max_p] of integer; //матрица смежности
   graph_inc: array [1..max_p,1..max_q] of integer; //матрица инцидентности
   graph_edg: array [1..max_q,1..2] of integer; //список ребер
   graph_lst_out: array [1..max_p,1..max_q] of integer; //списки смежности (исходящих ребер)
   graph_lst_in: array [1..max_p,1..max_q] of integer; //списки смежности (входящих ребер)
begin
   //ввод исходных данных (список ребер)
   writeln('translate graph from edge list to other');
   //определяем количество ребер графа
   write('number of edges: '); readln(q);

   //инициализация списка ребер
   for i:=1 to q do
   begin
      graph_edg[i,1]:=0;
      graph_edg[i,2]:=0;
   end;

   //автоматическая генерация списка ребер
   p:=random(10);
   for i:=1 to q do
   begin
      graph_edg[i,1]:=random(p)+1;
      graph_edg[i,2]:=random(p)+1;
   end;
{   
   //ввод списка ребер вручную
   for i:=1 to q do
   begin
      writeln('edge ',i,':');
      write(i,': start vertex='); readln(k); graph_edg[i,1]:=k;
      write(i,': end vertex='); readln(k); graph_edg[i,2]:=k;
   end;
   writeln('===========================================');
}
   //печать списка ребер      
   writeln('Edge list (',q,' edges)');
   for i:=1 to q do writeln(i,': (', graph_edg[i,1],',',graph_edg[i,2],')');

   //определение числа вершин
   //(максимальное значение номера начала или номера конца)
   p:=0;
   for i:=1 to q do
   begin
      if graph_edg[i,1]>p then p:=graph_edg[i,1];
      if graph_edg[i,2]>p then p:=graph_edg[i,2];
   end;
   
   //инициализация матрицы смежности
   for i:=1 to p do
      for j:=1 to p do
         graph_adj[i,j]:=0;

   //перевод списка ребер в матрицу смежности
   for i:=1 to q do
      graph_adj[graph_edg[i,1],graph_edg[i,2]]:=1;

   //печать матрицы смежности
   writeln('Adjacency matrix: ',p,'x',p,' vertexes');
   write('     '); for i:=1 to p do write(i:3); writeln;
   for i:=1 to p do
   begin
      write(i:3,': ');
      for j:=1 to p do write(graph_adj[i,j]:3);
      writeln;
   end;

   //инициализация матрицы инцидентности
   for i:=1 to p do
      for j:=1 to q do
         graph_inc[i,j]:=0;
      
   //перевод списка ребер в матрицу инцидентности
   for i:=1 to q do
   begin
      graph_inc[graph_edg[i,1],i]:=1;
      graph_inc[graph_edg[i,2],i]:=-1;
   end;
   
   //печать матрицы инцидентности
   writeln('Incidence matrix: ',p,' vertexes, ',q, ' edges');
   write('     '); for i:=1 to q do write(i:3); writeln;
   for i:=1 to p do
   begin
      write(i:3,': ');
      for j:=1 to q do write(graph_inc[i,j]:3);
      writeln;
   end;
   
   //инициализация списков смежности (исходящие ребра)
   for i:=1 to p do
      for j:=1 to q do
         graph_lst_out[i,j]:=0;
   
   //перевод списка ребер в списки смежности (исходящие ребра)
   for i:=1 to q do
   begin
      p_start:=graph_edg[i,1];
      if graph_lst_out[p_start,1]=0 then
      begin
         k:=0;
         for j:=i to q do
            if graph_edg[j,1]=p_start then
            begin
               k:=k+1;
               p_end:=graph_edg[j,2];
               graph_lst_out[p_start,k]:=p_end;
            end;
      end;
   end;
   
   //печать списков смежности (исходящие ребра)
   writeln('Adjacency list (outcoming)');
   for i:=1 to p do
   begin
      write(i,': ');
      j:=1;
      while (graph_lst_out[i,j]<>0)and(j<=q) do
      begin
         write(graph_lst_out[i,j]:3);
         j:=j+1;
      end;
      writeln;
   end;

   //инициализация списков смежности (входящие ребра)
   for i:=1 to p do
      for j:=1 to q do
         graph_lst_in[i,j]:=0;
   
   //перевод списка ребер в списки смежности (входящие ребра)
   for i:=1 to q do
   begin
      p_end:=graph_edg[i,2];
      if graph_lst_in[p_end,1]=0 then
      begin
         k:=0;
         for j:=i to q do
            if graph_edg[j,2]=p_end then
            begin
               k:=k+1;
               p_start:=graph_edg[j,1];
               graph_lst_in[p_end,k]:=p_start;
            end;
      end;
   end;
   
   //печать списков смежности (входящие ребра)
   writeln('Adjacency list (incoming)');
   for i:=1 to p do
   begin
      write(i,': ');
      j:=1;
      while (graph_lst_in[i,j]<>0)and(j<=q) do
      begin
         write(graph_lst_in[i,j]:3);
         j:=j+1;
      end;
      writeln;
   end;
      
end.
