-- Example 1
select * 
from sales_view
  model 
    partition by (country)
    dimension by (product, year)
    measures (sales, cnt)
    rules (
      sales['Bounce',2002] = sales['Bounce',2001] * 1.2
     ,cnt['Bounce',2002] = cnt['Bounce',2001] * 1.2
    );
    
-- Example 2
select * 
from sales_view
  model return updated rows
    partition by (country)
    dimension by (product, MOD(year,100) as year )
    measures (sales, cnt, 0 as price)
    rules (
      price['Bounce',99] = sales['Bounce',99] / cnt ['Bounce',99]
    )

-- Example 3. Return ALL rows.
select * 
from sales_view
  model return all rows
    partition by (country)
    dimension by (product, year)
    measures (sales, cnt)
    rules (
      sales['Bounce',2002] = sales['Bounce',2001] * 1.2
     ,cnt['Bounce',2002] = cnt['Bounce',2001] * 1.2
    );
    
-- Example 4. Return UPDATED rows.
select * 
from sales_view
  model return updated rows
    partition by (country)
    dimension by (product, year)
    measures (sales, cnt)
    rules (
      sales['Bounce',2002] = sales['Bounce',2001] * 1.2
     ,cnt['Bounce',2002] = cnt['Bounce',2001] * 1.2
    );
    
-- Example 5. Multi-cell ref. on the right side
select * 
from sales_view
  model 
    partition by (country, year)
    dimension by (product)
    measures (sales)
    rules (
      sales['TOTAL'] = sum(sales)[ANY]
    )
order by 
   country
  ,year
  ,case
     when product = 'TOTAL' then 1 
      else 0 
   end
  ,product;
  
  
-- Example 6. CV(dimension)
select * 
from sales_view
  model 
    partition by (country)
    dimension by (product,year)
    measures (sales)
    rules (
      sales[ANY,1999] = sales[cv(product),1998] * 2
    );

    
-- Example 7. CV()
select * 
from sales_view
  model 
    partition by (country)
    dimension by (product,year)
    measures (sales, cnt, 0 as price)
    rules (
      price[ANY,ANY] = sales[cv(),cv()] / cnt[cv(),cv()]   
    );
    
-- Example 8. Order By
select * 
from sales_view
  model return updated rows
    partition by (country)
    dimension by (product,year)
    measures (sales)
    rules upsert all (
      sales['IPhone 5', ANY] order by year = 
         case 
           when cv(year)=1998 then 100500
           else sales[cv(product),cv(year)-1] * 2
         end
    );

-- Example 9. UPDATE
select * 
from sales_view
  model return updated rows
    partition by (country)
    dimension by (product,year)
    measures (sales)
    rules update (
      sales['TOTAL',1998] = sum(sales)[ANY,1998]
    );

    
-- Example 10. UPSERT
select * 
from sales_view
  model return updated rows
    partition by (country)
    dimension by (product,year)
    measures (sales)
    rules upsert(
      sales['TOTAL',1998] = sum(sales)[ANY,1998]
     ,sales['TOTAL',year > 1998] = sum(sales)[ANY,cv()]
    );
    
-- Example 11. UPSERT ALL
select * 
from sales_view
  model return updated rows
    partition by (country)
    dimension by (product,year)
    measures (sales)
    rules upsert all(
      sales['TOTAL',1998] = sum(sales)[ANY,1998]
     ,sales['TOTAL',year > 1998] = sum(sales)[ANY,cv()]
    );
    
-- Example 12. Individual rule mode
select * 
from sales_view
  model return updated rows
    partition by (country)
    dimension by (product,year)
    measures (sales)
    rules UPSERT(
      sales['TOTAL',1998] = sum(sales)[ANY,1998]
     ,UPSERT ALL sales['TOTAL',year > 1998] = sum(sales)[ANY,cv()]
    );
