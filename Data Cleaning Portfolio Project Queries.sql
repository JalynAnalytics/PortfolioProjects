/*
Cleaning Data in SQL Queries
*/

-- Standarized Date Format

select saledate
from [Nashville Housing]


-- Populate Property Address data


select *
from [Nashville Housing]
--where propertyaddress is null
order by ParcelID



select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from [Nashville Housing] a
Join [Nashville Housing] b
	on a.ParcelID=b.ParcelID
	and a.UniqueID<>b.UniqueID
where a.PropertyAddress is null



update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from [Nashville Housing] a
Join [Nashville Housing] b
	on a.ParcelID=b.ParcelID
	and a.UniqueID<>b.UniqueID
where a.PropertyAddress is null


-- Breaking out Address into Individual Columns

select PropertyAddress
from [Nashville Housing]
--where propertyaddress is null
--order by ParcelID

SELECT 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',propertyaddress)-1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',',propertyaddress)+1, LEN(PropertyAddress))as Address
from [Nashville Housing]

Alter table [Nashville Housing]
add PropertySplitAddress Nvarchar(255);

Update [Nashville Housing]
Set PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',propertyaddress)-1)

Alter table [Nashville Housing]
add PropertySplitCity  Nvarchar(255);

Update [Nashville Housing]
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',propertyaddress)+1, LEN(PropertyAddress))







select OwnerAddress
from [Nashville Housing]

select 
PARSENAME(REPLACE(OwnerAddress,',','.'),3)
, PARSENAME(REPLACE(OwnerAddress,',','.'),2)
, PARSENAME(REPLACE(OwnerAddress,',','.'),1)
from [Nashville Housing]


Alter table [Nashville Housing]
add OwnerSplitAddress Nvarchar(255);

Update [Nashville Housing]
Set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

Alter table [Nashville Housing]
add OwnerSplitCity  Nvarchar(255);

Update [Nashville Housing]
Set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

Alter table [Nashville Housing]
add PropertySplitState  Nvarchar(255);

Update [Nashville Housing]
Set PropertySplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)


-- Change Y and N to Yes and No in "Sold as Vacant" field

select Distinct(SoldAsVacant),count(soldasvacant)
from [Nashville Housing]
group by SoldAsVacant
order by 2


SELECT SoldAsVacant,
   CASE 
      WHEN SoldAsVacant = 0 THEN 'No'
      WHEN SoldAsVacant = 1 THEN 'Yes'
   END 
FROM [Nashville Housing];

-- Changes SoldAsVacant column type from Bit to string

ALTER TABLE [Nashville Housing]
ALTER COLUMN SoldAsVacant VARCHAR(3);

UPDATE [Nashville Housing]
SET SoldAsVacant = 
   CASE 
      WHEN SoldAsVacant = 0 THEN 'No'
      WHEN SoldAsVacant = 1 THEN 'Yes'
   END;


-- Remove Duplicates

WITH RowNumCTE AS(
select *,
	ROW_NUMBER() OVER (
	PARTITION BY PARCELID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY UniqueID)
				  row_num


FROM [Nashville Housing]
--Order by ParcelID
)
 
SELECT *
 FROM RowNumCTE
 WHERE row_num>1


-- Delete Unused Columns


ALTER TABLE [Nashville Housing]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress





