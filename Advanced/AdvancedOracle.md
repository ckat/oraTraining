#Ссылки
HR/HR@evuakyisd0228.kyiv.epam.com:1521/trainings
SH/SH@evuakyisd0228.kyiv.epam.com:1521/trainings

#Схема
SH - sales history, star scheme - основная таблица 'sales'(фактов), где несколько fk и самая базовая информация

#Partitioned outer join (partition by)
dense data - только те продажи, которые действительно были'
sparse data - данные по всем продажам продуктов. Трудно получить, т.к. нет фактов.. left outer join не прокатит, если сразу несколько товаров
partiotion by - делает отдельные join по столбцу группировки, потом UNION. при этом в группировочном столбце всегда будет значение, в отличии от простого left join-а

with == subquery factory

#Иерархия
*для каждого уровня вложенности создается своя колонка(только в )
*Edges + aux data. id+ parent_id [+путь от вершины до узла]
*Nested set by Joe Celko (используется в Oracle ATG)
*Just edges (id + parent_id(self-referencing FK_PK)) - самая крутая. можно не только древовидные
start with - 'where' для первого уровня иерархии
connect by - условие joinа предыдущего к следующему
prior - колонка предыдущего уровня иерархии

порядок - joins, start with/connect, where, group by, order by
sys_connect_by_path - для сцепления уровней иерархии в строку
order siblings by - сортировка данных на одном уровне
connect by nocycle - отбрасывает закольцовывания (появляется переменная Connect_By_IsCycle 1|0), если нет prior в connect by - циклы убираются

#recursive WITH
всегда union all