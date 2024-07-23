/*

Cleaning Data in SQL Queries

*/

Select *
From PortfolioProject..[Nashville Housing]

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

Select SaleDate ,Convert (Date,SaleDate )
From PortfolioProject..[Nashville Housing]

ALTER TABLE PortfolioProject..[Nashville Housing]
add ConvertedSaleDate DATE;

Update PortfolioProject..[Nashville Housing]
set  ConvertedSaleDate = Convert (Date,SaleDate )




 --------------------------------------------------------------------------------------------------------------------------

 -- Populate Property Address data

 


Select a.ParcelID,a.PropertyAddress , b.ParcelID ,b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject..[Nashville Housing] as a	
join PortfolioProject..[Nashville Housing] as b 
on a.ParcelID = b.ParcelID and a.[UniqueID ] <> b.[UniqueID ]
 where a.PropertyAddress is null

 update a 
 set PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
 From PortfolioProject..[Nashville Housing] as a	
join PortfolioProject..[Nashville Housing] as b 
on a.ParcelID = b.ParcelID and a.[UniqueID ] <> b.[UniqueID ]
 where a.PropertyAddress is null

 --------------------------------------------------------------------------------------------------------------------------

 -- Breaking out Address into Individual Columns (Address, City, State)



 SELECT 
    -- Extract the address part before the comma
    SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) AS address,
    
    -- Extract the city part after the comma
    SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 2, LEN(PropertyAddress)) AS city
FROM 
    PortfolioProject..[Nashville Housing]

-- Update


	ALTER TABLE PortfolioProject..[Nashville Housing]
ADD PropertySplitAddress NVARCHAR(255);

Update PortfolioProject..[Nashville Housing]
SET PropertySplitAddress =   SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1)

ALTER TABLE PortfolioProject..[Nashville Housing]
ADD PropertySplitCity NVARCHAR(255);

Update PortfolioProject..[Nashville Housing]
SET PropertySplitCity =  SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 2, LEN(PropertyAddress))




-- split owner address

select OwnerAddress
from PortfolioProject..[Nashville Housing] 

SELECT 
    PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) AS AddressOwnerAddress,
    PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) AS CityOwnerAddress,
    PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1) AS StateOwnerAddress
FROM PortfolioProject..[Nashville Housing];

-- Update


	ALTER TABLE PortfolioProject..[Nashville Housing]
ADD  OwnerSplitAddress NVARCHAR(255);

Update PortfolioProject..[Nashville Housing]
SET OwnerSplitAddress =   PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE PortfolioProject..[Nashville Housing]
ADD  OwnerSplitCity NVARCHAR(255);

Update PortfolioProject..[Nashville Housing]
SET  OwnerSplitCity =   PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE PortfolioProject..[Nashville Housing]
ADD OwnerSplitState NVARCHAR(255);

Update PortfolioProject..[Nashville Housing]
SET OwnerSplitState =   PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)


--------------------------------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "Sold as Vacant" field 


select distinct (SoldAsVacant ),count (SoldAsVacant)
from PortfolioProject..[Nashville Housing] 
group by SoldAsVacant
order by 2

select SoldAsVacant ,
case
when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
else SoldAsVacant
end 
from PortfolioProject..[Nashville Housing] 

-- update 

update PortfolioProject..[Nashville Housing] 
set SoldAsVacant = 
case
when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
else SoldAsVacant
end 


--------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS (
SELECT *,
ROW_NUMBER() OVER (
    PARTITION BY 
        ParcelID,
        PropertyAddress,
        SalePrice,
        SaleDate,
        LegalReference
    ORDER BY UniqueID 
) AS row_num
FROM PortfolioProject..[Nashville Housing]

)
SELECT *
FROM RowNumCTE
where row_num >1 








---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns


Select *
From PortfolioProject..[Nashville Housing]

ALTER TABLE PortfolioProject..[Nashville Housing]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate


