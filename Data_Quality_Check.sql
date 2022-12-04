# Duplicate data in users
select _id, count(_id) from users
group by _id
having count(_id) > 1;

# Missing data in brands
select distinct item_brandcode from receipt_items 
where item_brandcode not in (select brandcode from brands)