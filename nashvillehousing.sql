select SaleDate, saledateconverted
from nashvillehousing

-- standardized sales date format.
select SaleDate ,convert(date, saledate) as saledateconverted
from nashvillehousing

alter table nashvillehousing
add saledateconverted date

update nashvillehousing
set Saledateconverted=convert(date, saledate) 

--populate property data address
select PropertyAddress
from nashvillehousing
where PropertyAddress is null

select *
from nashvillehousing
order by ParcelID
--notice correlation between parcelid and propertyAddress
--hence a self join 

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,isnull(a.propertyaddress,b.PropertyAddress)
from nashvillehousing a
join nashvillehousing b
on  a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = isnull(a.propertyaddress,b.PropertyAddress)
from nashvillehousing a
join nashvillehousing b
on  a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

--Breaking out Address into individual columns ,address, city,state.

select PropertyAddress
from nashvillehousing

select
substring(propertyaddress,1,charindex(',',propertyaddress)-1) as address,

substring(propertyaddress,charindex(',',propertyaddress)+1,len(propertyaddress)) as address
from nashvillehousing

alter table nashvillehousing
add propertyplitaddress nvarchar(255)

update nashvillehousing
set propertyplitaddress=substring(propertyaddress,1,charindex(',',propertyaddress)-1) 

alter table nashvillehousing
add propertysplitcity nvarchar(255)

update nashvillehousing
set propertysplitcity=substring(propertyaddress,charindex(',',propertyaddress)+1,len(propertyaddress))

select *
from nashvillehousing

--now owneraddress
select owneraddress
from nashvillehousing

select
parsename(replace(owneraddress,',', '.'),3),
parsename(replace(owneraddress,',', '.'),2),
parsename(replace(owneraddress,',', '.'),1)
from nashvillehousing

alter table nashvillehousing
add ownersplitaddress nvarchar(255)

update nashvillehousing
set ownersplitaddress=parsename(replace(owneraddress,',', '.'),3)

alter table nashvillehousing
add ownersplitcity nvarchar(255)

update nashvillehousing
set ownersplitcity=parsename(replace(owneraddress,',', '.'),2)

alter table nashvillehousing
add ownersplitstate nvarchar(255)

update nashvillehousing
set ownersplitstate=parsename(replace(owneraddress,',', '.'),1)



-- y and n , yes and no
select distinct (soldasvacant),count(soldasvacant)
from nashvillehousing
group by SoldAsVacant
order by 2

select soldasvacant,
case when SoldAsVacant= 'Y' then 'Yes'

when SoldAsVacant= 'N' then 'No'
else SoldAsVacant
end
from nashvillehousing

update nashvillehousing
set SoldAsVacant =case when SoldAsVacant= 'Y' then 'Yes'
when SoldAsVacant= 'N' then 'No'
else SoldAsVacant
end
from nashvillehousing

--Remove duplicates
with rownumcte as (
select*, 
row_number() over (
Partition by
		parcelid,
		propertyaddress,
		saleprice,
		saledate ,
		legalreference
		order by
			uniqueid
			) row_num
from nashvillehousing
--order by ParcelID
)
select *
from rownumcte
where row_num >1
--order by propertyaddress




--delete unused columns



select *
from nashvillehousing

alter table nashvillehousing
drop column owneraddress,taxdistrict,propertyplitcity,propertyaddress

alter table nashvillehousing
drop column saledate

--end