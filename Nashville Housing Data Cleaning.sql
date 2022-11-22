
-- Cleaning Data in SQL Queries


SELECT *
FROM PortfoiloProject.dbo.NashvilleHousing

-- Standardize Date Format

SELECT SaleDateConverted, CONVERT(Date, SaleDate) 
FROM PortfoiloProject.dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)


-- Populate Property Address data

SELECT *
FROM PortfoiloProject.dbo.NashvilleHousing
--WHERE PropertyAddress is null
ORDER BY ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfoiloProject.dbo.NashvilleHousing a
JOIN PortfoiloProject.dbo.NashvilleHousing b
   ON a.ParcelID = b.ParcelID
   AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfoiloProject.dbo.NashvilleHousing a
JOIN PortfoiloProject.dbo.NashvilleHousing b
   ON a.ParcelID = b.ParcelID
   AND a.[UniqueID ] <> b.[UniqueID ]
 WHERE a.PropertyAddress is null

 
 --Breaking out Address into Individual Columns (Address, City, State)

 SELECT PropertyAddress
FROM PortfoiloProject.dbo.NashvilleHousing

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1, LEN(PropertyAddress))  as Address

FROM PortfoiloProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress NvarChar(255);

UPDATE NashvilleHousing
SET PropertySplitAddress  = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1)

ALTER TABLE NashvilleHousing
ADD PropertySpiltCity NvarChar(255);

UPDATE NashvilleHousing
SET PropertySpiltCity  = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1, LEN(PropertyAddress))


SELECT *
FROM PortfoiloProject.dbo.NashvilleHousing

SELECT OwnerAddress
FROM PortfoiloProject.dbo.NashvilleHousing


SELECT
PARSENAME(REPLACE(OwnerAddress,',', ',') , 3)
, PARSENAME(REPLACE(OwnerAddress,',', ',') , 2)
, PARSENAME(REPLACE(OwnerAddress,',', ',') , 1)
FROM PortfoiloProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
ADD OwnerSpiltAddress NvarChar(255);

UPDATE NashvilleHousing
SET OwnerSpiltAddress  = PARSENAME(REPLACE(OwnerAddress,',', ',') , 3)

ALTER TABLE NashvilleHousing
ADD  OwnerSpiltCity   NvarChar(255);

UPDATE NashvilleHousing
SET OwnerSpiltCity  = PARSENAME(REPLACE(OwnerAddress,',', ',') , 2)

ALTER TABLE NashvilleHousing
ADD OwnerSpiltState NvarChar(255);

UPDATE NashvilleHousing
SET OwnerSpiltState  =  PARSENAME(REPLACE(OwnerAddress,',', ',') , 1)

SELECT *
FROM PortfoiloProject.dbo.NashvilleHousing



-- Change Y and N to Yes and NO  in "Sold as Vacant" field

SELECT Distinct (SoldAsVacant), COUNT(SoldAsVacant)
FROM PortfoiloProject.dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2



SELECT SoldAsVacant
,   CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
        WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END
FROM PortfoiloProject.dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
        WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END



-- Remove Duplicates

WITH RowNumCTE AS(
SELECT *,
    ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
	             PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
				   UniqueID
				   ) row_num
FROM PortfoiloProject.dbo.NashvilleHousing
--ORDER BY ParcelID
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1
--ORDER BY PropertyAddress





-- Delect Unused Columns


SELECT *
FROM PortfoiloProject.dbo.NashvilleHousing

ALTER TABLE PortfoiloProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict,PropertyAddress, SaleDate