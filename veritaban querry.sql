CREATE DATABASE TelefonVeBilgisayarSatis;
GO

USE TelefonVeBilgisayarSatis;
GO

CREATE TABLE Customers (
    CustomerID VARCHAR(64) NOT NULL PRIMARY KEY,
    FirstName VARCHAR(64) NOT NULL,
    LastName VARCHAR(64) NOT NULL,
    PhoneNumber VARCHAR(25) NOT NULL,
    Email VARCHAR(250) NOT NULL,
    Address VARCHAR(250) NOT NULL
);
GO

CREATE TABLE Products (
    ProductID VARCHAR(64) NOT NULL PRIMARY KEY,
    ProductName VARCHAR(250) NOT NULL,
    Category VARCHAR(50) NOT NULL,
    UnitPrice FLOAT NOT NULL,
    Description VARCHAR(250) NOT NULL,
    StockQuantity FLOAT NOT NULL,
    Unit VARCHAR(16) NOT NULL
);
GO

CREATE TABLE Sales (
    SaleID VARCHAR(64) NOT NULL PRIMARY KEY,
    CustomerID VARCHAR(64) NOT NULL,
    ProductID VARCHAR(64) NOT NULL,
    SaleDate DATETIME NOT NULL,
    SalePrice FLOAT NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID) ON DELETE CASCADE ON UPDATE CASCADE
);
GO

CREATE TABLE Payments (
    PaymentID VARCHAR(64) NOT NULL PRIMARY KEY,
    CustomerID VARCHAR(64) NOT NULL,
    PaymentDate DATETIME NOT NULL,
    PaymentAmount FLOAT NOT NULL,
    PaymentMethod VARCHAR(25) NOT NULL,
    Description VARCHAR(250) NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) ON DELETE CASCADE ON UPDATE CASCADE
);
GO


CREATE PROCEDURE AddCustomer
    @CustomerID VARCHAR(64),
    @FirstName VARCHAR(64),
    @LastName VARCHAR(64),
    @PhoneNumber VARCHAR(25),
    @Email VARCHAR(250),
    @Address VARCHAR(250)
AS
BEGIN
    INSERT INTO Customers (CustomerID, FirstName, LastName, PhoneNumber, Email, Address)
    VALUES (@CustomerID, @FirstName, @LastName, @PhoneNumber, @Email, @Address);
END;
GO

CREATE PROCEDURE UpdateCustomer
    @CustomerID VARCHAR(64),
    @FirstName VARCHAR(64),
    @LastName VARCHAR(64),
    @PhoneNumber VARCHAR(25),
    @Email VARCHAR(250),
    @Address VARCHAR(250)
AS
BEGIN
    UPDATE Customers
    SET 
        FirstName = @FirstName,
        LastName = @LastName,
        PhoneNumber = @PhoneNumber,
        Email = @Email,
        Address = @Address
    WHERE 
        CustomerID = @CustomerID;
END;
GO

CREATE PROCEDURE DeleteCustomer
    @CustomerID VARCHAR(64)
AS
BEGIN
    DELETE FROM Customers
    WHERE CustomerID = @CustomerID;
END;
GO

CREATE PROCEDURE ListCustomers
AS
BEGIN
    SELECT * FROM Customers;
END;
GO
---------------------------
CREATE PROCEDURE AddProduct
    @ProductID VARCHAR(64),
    @ProductName VARCHAR(250),
    @Category VARCHAR(50),
    @UnitPrice FLOAT,
    @Description VARCHAR(250),
    @StockQuantity FLOAT,
    @Unit VARCHAR(16)
AS
BEGIN
    INSERT INTO Products (ProductID, ProductName, Category, UnitPrice, Description, StockQuantity, Unit)
    VALUES (@ProductID, @ProductName, @Category, @UnitPrice, @Description, @StockQuantity, @Unit);
END;
GO
--------------
CREATE PROCEDURE UpdateProduct
    @ProductID VARCHAR(64),
    @ProductName VARCHAR(250),
    @Category VARCHAR(50),
    @UnitPrice FLOAT,
    @Description VARCHAR(250),
    @StockQuantity FLOAT,
    @Unit VARCHAR(16)
AS
BEGIN
    UPDATE Products
    SET 
        ProductName = @ProductName,
        Category = @Category,
        UnitPrice = @UnitPrice,
        Description = @Description,
        StockQuantity = @StockQuantity,
        Unit = @Unit
    WHERE 
        ProductID = @ProductID;
END;
GO

CREATE PROCEDURE ViewProductDetails
    @ProductID VARCHAR(64)
AS
BEGIN
    SELECT * FROM Products
    WHERE ProductID = @ProductID;
END;
GO
CREATE PROCEDURE DeleteProduct
    @ProductID VARCHAR(64)
AS
BEGIN
    DELETE FROM Products
    WHERE ProductID = @ProductID;
END;
GO
-------------------------
CREATE PROCEDURE AddSale
    @SaleID VARCHAR(64),
    @CustomerID VARCHAR(64),
    @ProductID VARCHAR(64),
    @SaleDate DATETIME,
    @SalePrice FLOAT
AS
BEGIN
    INSERT INTO Sales (SaleID, CustomerID, ProductID, SaleDate, SalePrice)
    VALUES (@SaleID, @CustomerID, @ProductID, @SaleDate, @SalePrice);
END;
GO
CREATE PROCEDURE UpdateSale
    @SaleID VARCHAR(64),
    @CustomerID VARCHAR(64),
    @ProductID VARCHAR(64),
    @SaleDate DATETIME,
    @SalePrice FLOAT
AS
BEGIN
    UPDATE Sales
    SET 
        CustomerID = @CustomerID,
        ProductID = @ProductID,
        SaleDate = @SaleDate,
        SalePrice = @SalePrice
    WHERE 
        SaleID = @SaleID;
END;
GO
CREATE PROCEDURE ViewSaleDetails
    @SaleID VARCHAR(64)
AS
BEGIN
    SELECT * FROM Sales
    WHERE SaleID = @SaleID;
END;
GO
CREATE PROCEDURE DeleteSale
    @SaleID VARCHAR(64)
AS
BEGIN
    DELETE FROM Sales
    WHERE SaleID = @SaleID;
END;
GO
CREATE PROCEDURE DeleteSale
    @SaleID VARCHAR(64)
AS
BEGIN
    DELETE FROM Sales
    WHERE SaleID = @SaleID;
END;
GO
---------------
USE TelefonVeBilgisayarSatis;
GO
CREATE TRIGGER trg_UpdateStockAfterSale
ON Sales
AFTER INSERT
AS
BEGIN
    DECLARE @ProductID VARCHAR(64)
    DECLARE @QuantitySold FLOAT

    SELECT @ProductID = ProductID, @QuantitySold = SalePrice FROM inserted

    UPDATE Products
    SET StockQuantity = StockQuantity - @QuantitySold
    WHERE ProductID = @ProductID
END;
GO

----------------
CREATE TRIGGER trg_ValidateSalePrice
ON Sales
BEFORE INSERT, UPDATE
AS
BEGIN
    DECLARE @ProductID VARCHAR(64)
    DECLARE @SalePrice FLOAT

    SELECT @ProductID = ProductID, @SalePrice = SalePrice FROM inserted

    IF @SalePrice < (SELECT UnitPrice FROM Products WHERE ProductID = @ProductID)
    BEGIN
        RAISERROR ('Sale price cannot be less than the unit price of the product.', 16, 1)
        ROLLBACK TRANSACTION
    END
END;
GO
--------------------
CREATE TABLE PaymentHistory (
    PaymentID VARCHAR(64),
    CustomerID VARCHAR(64),
    PaymentDate DATETIME,
    PaymentAmount FLOAT,
    PaymentMethod VARCHAR(25),
    Description VARCHAR(250),
    LogDate DATETIME
);

CREATE TRIGGER trg_LogPayment
ON Payments
AFTER INSERT
AS
BEGIN
    INSERT INTO PaymentHistory (PaymentID, CustomerID, PaymentDate, PaymentAmount, PaymentMethod, Description, LogDate)
    SELECT PaymentID, CustomerID, PaymentDate, PaymentAmount, PaymentMethod, Description, GETDATE()
    FROM inserted
END;
GO
----------------------
CREATE TRIGGER trg_PreventCustomerDeletion
ON Customers
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Sales WHERE CustomerID IN (SELECT CustomerID FROM deleted))
    BEGIN
        RAISERROR ('Cannot delete customer who has associated sales.', 16, 1)
        ROLLBACK TRANSACTION
    END
    ELSE
    BEGIN
        DELETE FROM Customers WHERE CustomerID IN (SELECT CustomerID FROM deleted)
    END
END;
GO
---------------------------------
CREATE TRIGGER trg_UpdateStockAfterSale
ON Sales
AFTER INSERT
AS
BEGIN
    DECLARE @ProductID VARCHAR(64)
    DECLARE @SaleQuantity FLOAT

    SELECT @ProductID = ProductID, @SaleQuantity = SalePrice FROM inserted -- Assuming SalePrice is used to denote the quantity sold

    UPDATE Products
    SET StockQuantity = StockQuantity - @SaleQuantity
    WHERE ProductID = @ProductID
END;
GO
---------------------
CREATE TRIGGER trg_ValidateSalePrice
ON Sales
BEFORE INSERT, UPDATE
AS
BEGIN
    DECLARE @ProductID VARCHAR(64)
    DECLARE @SalePrice FLOAT

    SELECT @ProductID = ProductID, @SalePrice = SalePrice FROM inserted

    IF @SalePrice < (SELECT UnitPrice FROM Products WHERE ProductID = @ProductID)
    BEGIN
        RAISERROR ('Sale price cannot be less than the unit price of the product.', 16, 1)
        ROLLBACK TRANSACTION
    END
END;
GO
----------------------------
CREATE TABLE PaymentHistory (
    PaymentID VARCHAR(64),
    CustomerID VARCHAR(64),
    PaymentDate DATETIME,
    PaymentAmount FLOAT,
    PaymentMethod VARCHAR(25),
    Description VARCHAR(250),
    LogDate DATETIME
);

CREATE TRIGGER trg_LogPayment
ON Payments
AFTER INSERT
AS
BEGIN
    INSERT INTO PaymentHistory (PaymentID, CustomerID, PaymentDate, PaymentAmount, PaymentMethod, Description, LogDate)
    SELECT PaymentID, CustomerID, PaymentDate, PaymentAmount, PaymentMethod, Description, GETDATE()
    FROM inserted
END;
GO
---------------------------
CREATE TRIGGER trg_PreventCustomerDeletion
ON Customers
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Sales WHERE CustomerID IN (SELECT CustomerID FROM deleted))
    BEGIN
        RAISERROR ('Cannot delete customer who has associated sales.', 16, 1)
        ROLLBACK TRANSACTION
    END
    ELSE
    BEGIN
        DELETE FROM Customers WHERE CustomerID IN (SELECT CustomerID FROM deleted)
    END
END;
GO
-------------------------------
