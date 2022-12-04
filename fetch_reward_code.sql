USE fetch_rewards;
# Problem 1
# Current query count brands no matter the brandcode is in brands table.
select item_brandCode, count(item_brandCode) as c from receipt_items 
where receipt_items.item_brandCode != '' # and receipt_items.item_brandCode in (select brandcode from brands)  # add this line to exclude brand codes if not listed in brands table
# and month(FROM_UNIXTIME(receipt_dateScanned/1000)) = month(now())-1 # Add this line for most recent month
group by item_brandCode
order by c desc
limit 5;

# Problem 2
# dateScanned only contains date in 2020/10 - 2020/11 and 2021/01 - 2021/03
select month(FROM_UNIXTIME(dateScanned/1000)), year(FROM_UNIXTIME(dateScanned/1000)) from receipts group by 1,2 order by 2, 1;

# Problem 3 & 4
# Assume rewardsReceiptStatus Accepted is Finished
SELECT rewardsReceiptStatus, sum(CAST(purchasedItemCount AS DECIMAL)), avg(CAST(totalSpent AS DECIMAL))
FROM receipts
where rewardsReceiptStatus = 'FINISHED' or rewardsReceiptStatus = 'REJECTED'
group by rewardsReceiptStatus;

# Problem 5
# Assume estimated spend is calculated by final price * purchased item count
select item_brandCode, sum(item_finalPrice * item_quantityPurchased) as estimate_spend
from receipt_items
where item_brandCode != '' and receipt_userId in (select _id from users) # where FROM_UNIXTIME(createdDate/1000) > DATE_SUB(now(), INTERVAL 28 MONTH))
group by item_brandCode
order by estimate_spend desc;

# Problem 6
# Assume one receipt equals one transaction
select item_brandCode, count(distinct receipt__id) as count_receipts
from receipt_items
where receipt_userId in (select _id from users) # where FROM_UNIXTIME(createdDate/1000) > DATE_SUB(now(), INTERVAL 28 MONTH))
group by item_brandCode
order by count_receipts desc
