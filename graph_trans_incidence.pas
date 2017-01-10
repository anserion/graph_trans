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

//учебный шаблон перевода интерпретации графа из матрицы инцидентности
//в список ребер, список смежности, матрицу смежности.

program graph_trans_incidence;
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
   //ввод исходных данных (матрица инцидентности)
   writeln('translate graph from incidence matrix to other');
   //определяем количество вершин графа
   write('number of vertexes: '); readln(p);
   //определяем количество ребер графа
   write('number of edges: '); readln(q);

   //инициализация матрицы инцидентности
   for i:=1 to p do
      for j:=1 to q do
         graph_inc[i,j]:=0;

   //автоматическая генерация матрицы инцидентности
   for i:=1 to q do
   begin
      graph_inc[random(p)+1,i]:=1;
      graph_inc[random(p)+1,i]:=-1;
   end;
{
   //ввод матрицы инцидентности вручную
   for i:=1 to q do
   begin
      writeln('edge ',i,':');
      write(i,': start vertex='); readln(k); graph_inc[k,i]:=1;
      write(i,': end vertex='); readln(k); graph_inc[k,i]:=-1;
   end;
   writeln('===========================================');
}
   //печать матрицы инцидентности
   writeln('Incidence matrix: ',p,' vertexes, ',q, ' edges');
   write('     '); for i:=1 to q do write(i:3); writeln;
   for i:=1 to p do
   begin
      write(i:3,': ');
      for j:=1 to q do write(graph_inc[i,j]:3);
      writeln;
   end;
   
   //инициализация матрицы смежности
   for i:=1 to p do
      for j:=1 to p do
         graph_adj[i,j]:=0;

   //перевод матрицы инцидентности в матрицу смежности
   for i:=1 to q do
   begin
      p_start:=0; p_end:=0;
      for j:=1 to p do
      begin
         if graph_inc[j,i]=1 then p_start:=j;
         if graph_inc[j,i]=-1 then p_end:=j;
      end;
      if p_start=0 then p_start:=p_end;
      if p_end=0 then p_end:=p_start;
      graph_adj[p_start,p_end]:=1;
   end;

   //печать матрицы смежности
   writeln('Adjacency matrix: ',p,'x',p,' vertexes');
   write('     '); for i:=1 to p do write(i:3); writeln;
   for i:=1 to p do
   begin
      write(i:3,': ');
      for j:=1 to p do write(graph_adj[i,j]:3);
      writeln;
   end;

   //инициализация списка ребер
   for i:=1 to q do
   begin
      graph_edg[i,1]:=0;
      graph_edg[i,2]:=0;
   end;
   
   //перевод матрицы инцидентности в список ребер
   for i:=1 to q do
   begin
      p_start:=0; p_end:=0;
      for j:=1 to p do
      begin
         if graph_inc[j,i]=1 then p_start:=j;
         if graph_inc[j,i]=-1 then p_end:=j;
      end;
      if p_start=0 then p_start:=p_end;
      if p_end=0 then p_end:=p_start;
      graph_edg[i,1]:=p_start;
      graph_edg[i,2]:=p_end;
   end;
   
   //печать списка ребер      
   writeln('Edge list (',q,' edges)');
   for i:=1 to q do writeln(i,': (', graph_edg[i,1],',',graph_edg[i,2],')');
   
   //инициализация списков смежности (исходящие ребра)
   for i:=1 to p do
      for j:=1 to q do
         graph_lst_out[i,j]:=0;
   
   //перевод матрицы инцидентности в списки смежности (исходящие ребра)
   for p_start:=1 to p do
   begin
      k:=0;
      for j:=1 to q do
         if graph_inc[p_start,j]=1 then
         begin
            k:=k+1;
            graph_lst_out[p_start,k]:=p_start;
            for p_end:=1 to p do
               if graph_inc[p_end,j]=-1 then graph_lst_out[p_start,k]:=p_end;
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
   
   //перевод матрицы инцидентности в списки смежности (входящие ребра)
   for p_end:=1 to p do
   begin
      k:=0;
      for j:=1 to q do
         if graph_inc[p_end,j]=-1 then
         begin
            k:=k+1;
            graph_lst_in[p_end,k]:=p_end;
            for p_start:=1 to p do 
               if graph_inc[p_start,j]=1 then graph_lst_in[p_end,k]:=p_start;
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
