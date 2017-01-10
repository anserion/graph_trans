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

//учебный шаблон перевода интерпретации графа из матрицы смежности
//в список ребер, список смежности, матрицу инцидентности.

program graph_trans_adjacency;
const
   max_p=100;
   max_q=100;

var i,j,k,p,q:integer;
   graph_adj: array [1..max_p,1..max_p] of integer; //матрица смежности
   graph_inc: array [1..max_p,1..max_q] of integer; //матрица инцидентности
   graph_edg: array [1..max_q,1..2] of integer; //список ребер
   graph_lst_out: array [1..max_p,1..max_q] of integer; //списки смежности (исходящих ребер)
   graph_lst_in: array [1..max_p,1..max_q] of integer; //списки смежности (входящих ребер)
begin
   //ввод исходных данных (матрица смежности)
   writeln('translate graph from adjacence matrix to other');
   //определяем количество вершин графа
   write('number of vertexes: '); readln(p);
   
   //инициализация матрицы смежности
   for i:=1 to p do
      for j:=1 to p do
         graph_adj[i,j]:=0;

   //автоматическая генерация матрицы смежности
   for i:=1 to p do
      for j:=1 to p do
         graph_adj[i,j]:=random(2);
{   
   //ввод матрицы смежности вручную
   for i:=1 to p do
   begin
      for j:=1 to p do
      begin
         write('vertex ',i,' start of edge (1), no edge (0) to vertex ',j,': ');
         readln(graph_adj[i,j]);
      end;
      writeln('===========================================');
   end;
}  
   //печать матрицы смежности
   writeln('Adjacency matrix: ',p,'x',p,' vertexes');
   write('     '); for i:=1 to p do write(i:3); writeln;
   for i:=1 to p do
   begin
      write(i:3,': ');
      for j:=1 to p do write(graph_adj[i,j]:3);
      writeln;
   end;

   //подсчет числа ребер графа по его матрице смежности
   q:=0;
   for i:=1 to p do
      for j:=1 to p do
         if graph_adj[i,j]<>0 then q:=q+1;
   
   //инициализация матрицы инцидентности
   for i:=1 to p do
      for j:=1 to q do
         graph_inc[i,j]:=0;
   
   //перевод матрицы смежности в матрицу инцидентности
   k:=0;
   for i:=1 to p do
      for j:=1 to p do
         if graph_adj[i,j]<>0 then
         begin
            k:=k+1;
            graph_inc[i,k]:=1;
            graph_inc[j,k]:=-1;
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
   
   //инициализация списка ребер
   for i:=1 to q do
   begin
      graph_edg[i,1]:=0;
      graph_edg[i,2]:=0;
   end;
   
   //перевод матрицы смежности в список ребер
   k:=0;
   for i:=1 to p do
      for j:=1 to p do
         if graph_adj[i,j]<>0 then
         begin
            k:=k+1;
            graph_edg[k,1]:=i;
            graph_edg[k,2]:=j;
         end;
   
   //печать списка ребер      
   writeln('Edge list (',q,' edges)');
   for i:=1 to q do writeln(i,': (', graph_edg[i,1],',',graph_edg[i,2],')');
   
   //инициализация списков смежности (исходящие ребра)
   for i:=1 to p do
      for j:=1 to q do
         graph_lst_out[i,j]:=0;
   
   //перевод матрицы смежности в списки смежности (исходящие ребра)
   for i:=1 to p do
   begin
      k:=0;
      for j:=1 to p do
         if graph_adj[i,j]<>0 then
         begin
            k:=k+1;
            graph_lst_out[i,k]:=j;
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
   
   //перевод матрицы смежности в списки смежности (входящие ребра)
   for i:=1 to p do
   begin
      k:=0;
      for j:=1 to p do
         if graph_adj[j,i]<>0 then
         begin
            k:=k+1;
            graph_lst_in[i,k]:=j;
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
