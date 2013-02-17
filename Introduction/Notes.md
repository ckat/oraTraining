#Проверялка
http://evuakyisd0228.kyiv.epam.com:8080/apex/f?p=102
alexander_kudryavtcev

#perfomance
	SELECT * FROM V$SQLSTATS

#Даты
	'01-Sep-2012' - зависит от локали, не использовать
	(alter session set nls_territory='CIS'/СНГ 'AMERICA')
	DATE'yyyy-mm-dd', TO_DATE('01.01.2012 13:00:01', 'dd.mm.yyyy hh24:mi:ss') - не зависит от настроек сессии.
	тип DATE не хранит TZ
	date + 1 = + 1 день, date + 1/24 = + 1 час
	ADD_MONTH - не перепрыгивает через месяц никогда
	NEXT_DAY - страховаться в параметре названия дня недели через TO_CHAR(DATE'2012-20-01', 'day')
	EXTRACT - числовые значения полей даты (год, час и т.п.)
	INTERVAL 'num' <type - DAY, SECOND> - возвращает дату содержащую этот интервал

#строки
	индексация с 1
	TRANSLATE - попарная замена (1й элемент входного алфавита меняется на 1й выходного), если в выходных не хватает значения,
	будет удаление соовтетствуюющих входных элементов
	LIKE '%sds$%f% escape '$' - сэкранирует средний %
 

#Сортировка
	ORDER BY жрет не только колонки, но и индексы в запросе, алиасы, сложные выражения
	ASC и DESC относятся только к одному параметру ORDER BY
	NULL - по-умолчанию считается большим значение (nulls last, nulls first)
	rownum Отрабатывает ___ДО___ сортировки
	pagination - в три этапа (во втором - мы "запоминаем rownum" подзапроса,
	чтобы потом спокойно внешним запросом обработать) select rownum as rn, sub1.* from () as sub

	
DBMS_RANDOM.string('A', X) - создает случайную строку

#Агрегация
	count(distinct ROW) - подсчитает только уникальные
	count(*) == count(1)
	empty dataset -> count = 0, остальные - NULL
	последовательность выполнения: WHERE -> GROUP BY -> ORDER BY
	в where нельзя использовать результаты агрегации -> использовать HAVING
	Вложенные функции агрегации MAX(AVG(row)) - только с GROUP BY, уровень вложенности - только до 2
	ListAgg(row, ', ') WITHING GROUP (личный order by, для сортировки внутри строки) - групповой конкат значений из GROUP BY
	результат - до 4к символов(коренная особенность SQL)
	sys_connect_by_path

#Подзапросы
	
	##Скалярные - возвращают только одно значение(1 строка и один столбец).Использовать можно везде, кроме GROUP BY.
	
	##Более одной колонки - только в WHERE или в HAVING, '=' and '<>'
	(WHERE (x1, y1) = (select x2, y2  from dual))- tuple

	##Multirow
	[NOT] IN , [NOT] EXISTS (есть ли хоть какой-то результат) , ANY(sugar), ALL(sugar)
	NOT IN == false, если дать на вход NULL

	##Multicolumn
	NOT IN раскрывается в x1 <> x2 or y1 <> y2

	##Коррелированные запросы
	Используют колонки основного запроса
	perfomance-hit 

	##inline view
	Используют во FROM. Всегда задавать alias для колонок. Не может быть коррелированным


#Операции со множествами запросов
	UNION - объединяет результаты запросов одного типа, дубликаты убираются
	UNION ALL - дубликаты остаются(быстрее, лучше использовать по-умолчанию)
	Имена полей берутся из первого блока
	MINUS - Убирает из одного множества все значения второго множества
	INTERSECT - выбираются только то записи присутствующие в обоих
	порядок стандартный, можно менять скобки
	ORDER BY только в последнем блоке, ссылаться только на поля первого запроса

#DML
	update можно накладывать на результаты подзапроса(inline view) (нет GROUP  BY, DISTINCT, key-preserved table rule)
	MERGE - одновременно insert и update [delete], для синхронизации данных между таблицами. Условие ON требует окружающих скобочек). В каждой части можно ограничить через where
	Multi INSERT - INSERT FIRST[одна запись только в одну таблицу], SEVERAL

	TRUNCATE(DDL! => unable to rollback, auto commit previous transactions) - стирает быстро содержимое таблицы, сразу всё. Требует права DROP

#Транзакции
	UNDO tablespace - скидываются исходные данные. Выше быстродействие, если транзакция подтверждается, когда откат - приходится переносить в оригинал.
	В многопользовательском режиме может привести к нарушению согласованности.
	Invisible or complete transaction(by J. Lewis): locking(nobody can read, MS SQL) or versioning(Oracle approach, БД реконструирует для второй транзакции данные с помощью UNDO table. Read costistency - считывается последняя целостная версия)
	ORA-01555 snapshot too old - не получилось реконструировать из UNDO целостные данные для новой транзакции
	Транзакция только одна на сессию commit.
	для функции можно выставить pragma autonomous_transaction(для логирования хорошо)
	ORA-00060 - deadlock, одну из транзакций грохнуло, во имя выживания

	Проблемы
		Dirty read - чтение незакоммиченных данных

		Non-repeatable read - чтения одних и тех же данных в рамках одной транзакций может приводить к разным результатам(если другая транзакция закоммитит между изменениями)

		Phantom read - вылазят новые данные
	Isolation levels ANSI:
		read uncommited (минимальный)
		read committed (фантомы +)
		repatable Read (остаются фантомы)
		serializable (строжайщая)
	Oracle isolation levels:
		*read commited(по-умолчанию. На уровне транзак. При вызове выражения - все данные во время его выполнения реконструируются на момент запуска выражения. через undo + SCN. для транзакции - read commited, для выражения - работает как serializable)
		SCN - при каждом коммите увеличивается счетчик.
		*serializable - транзакция будет работать со снэпшотом БД
		set transaction isolation level serializable

	Atomacity
	Consistency
	Isolation
	Durability

	Buffer Cache - кэш данных Oracle, при достижении чекпоинта - синхронизируется с диском
	Redo log - данные о том КАК менялись в "быстром" формате. flush на диск при коммите.
	потихоньку пишется во время самой транзакции

	транзакция стартует при первом DML
	или set transaction
	или select for update
	from distributed selects
	заканчивает rollback, commit или DDL выражение, при конце сессии(зависит от клиента, по-умолчанию откатывает)

#Схемы
	dba_tables -  все таблицы по пользователям
	v$ - dynamic perfomance views
	user_* - for current scheme
	all_* - all that current user can access

	v$session - текущие сессии пользователей (sqlid - текущий запрос, blocking_session)
	v$lock - 
	v$sqlarea - sql запросы
	v$session_longops - сбрасываются логи про долгие операции
	трассировка keywords(DBMS_MONITOR, event 10046, oracle perfomance tuning by Хольт)
	ALTER system SET processes = 900 scope=spfile; - увеличиваем количество сессий до 900
	select username, count(1) CNT from v$session GROUP BY username ORDER BY CNT DESC ; - смотрим жадных пользователей

	number(p,s): p - значащих разрядов, s - после запятой, s- приоритетнее. s может быть отрицательным, можно округлять

	ORA-1438 - не влезло значение в тип (слева)
	varchar - do not use
	char игнорирует пробелы в конце при сравнении(т.к добивается ими в БД до заданного размера), varchar2 - нет. По дефолту - размер байты(!), настраивается через nls_semantics
	CLOB - использует кодировка, BLOB - чисто бинарный
	LONG - аналог CLOB, устаревший тип, не использовать
	RAW - до 2000байт бинарных данных
	TIMESTAMP - хранит в т.ч. доли секунды
	есть интервальные типы времени (чтобы удобно прибавлять, удалять)

#Constraint
	not null - легчайший констраint, можно делать неименованным, можно делать инлайн. Расценивается как свойство таблицы. меняется через modify

	select * from user_constraints where table_name = 'xxx'
	UNIQUE - null не считаются дубликатами
	Задается: сразу после поля - constaint <name> тип ограничения
	после полей - constraint <name> uniq(field1, field2)
	alter table <table>
		add constraint <name>
		unique(field1, field2)
	любой integrity constraint можно перевести в режим deffered(откладывание проверки до конца транзакции, а не выражения ) unique constaint можно сделать deffered

#Views
	простой - хранит только текст запроса, materialized view - ещё и результаты 
	create or replace view <name> as <query>
	DML над view: автоматома проваливаются к таблицам
	key-preserved  - DML возможна если соответствует PK view и PK table
	Можно расширить DML над view через триггеры 'instead of' 
	Избавиться от пропадания строк, при редактировании пользовтелем записи таким образом, что запись пропадет из view использовать опцию with check option при создании view
	with read only; - запрещает выполнение над view операций DML

#nextval
	seq.nextval - генерирует новый id
	seq.currval - последнее сгенерированный id в _рамках сессии_
	nextval генерится од