CREATE PROCEDURE InsertOrderDetails
    @OrderID INT,
    @ProductID INT,
    @UnitPrice DECIMAL(10, 2) = NULL,
    @Quantity INT,
    @Discount DECIMAL(4, 2) = 0
AS
BEGIN
    DECLARE @ProductUnitPrice DECIMAL(10, 2)
    DECLARE @UnitsInStock INT
    DECLARE @ReorderLevel INT
    
    -- Get the unit price from the Product table if not provided
    IF @UnitPrice IS NULL
    BEGIN
        SELECT @ProductUnitPrice = UnitPrice
        FROM Product
        WHERE ProductID = @ProductID
    END
    ELSE
    BEGIN
        SET @ProductUnitPrice = @UnitPrice
    END

    -- Check stock levels
    SELECT @UnitsInStock = UnitsInStock, @ReorderLevel = ReorderLevel
    FROM Product
    WHERE ProductID = @ProductID

    IF @UnitsInStock < @Quantity
    BEGIN
        PRINT 'Failed to place the order. Not enough stock available.'
        RETURN
    END

    -- Insert order details
    INSERT INTO OrderDetails (OrderID, ProductID, UnitPrice, Quantity, Discount)
    VALUES (@OrderID, @ProductID, @ProductUnitPrice, @Quantity, @Discount)

    -- Check if the insert was successful
    IF @@ROWCOUNT = 0
    BEGIN
        PRINT 'Failed to place the order. Please try again.'
        RETURN
    END

    -- Update stock levels
    UPDATE Product
    SET UnitsInStock = UnitsInStock - @Quantity
    WHERE ProductID = @ProductID

    -- Check if stock level is below reorder level
    IF @UnitsInStock - @Quantity < @ReorderLevel
    BEGIN
        PRINT 'Warning: The quantity in stock of a product drops below its reorder level.'
    END
END

CREATE PROCEDURE UpdateOrderDetails
    @OrderID INT,
    @ProductID INT,
    @UnitPrice DECIMAL(10, 2) = NULL,
    @Quantity INT = NULL,
    @Discount DECIMAL(4, 2) = NULL
AS
BEGIN
    DECLARE @CurrentUnitPrice DECIMAL(10, 2)
    DECLARE @CurrentQuantity INT
    DECLARE @CurrentDiscount DECIMAL(4, 2)
    DECLARE @UnitsInStock INT
    DECLARE @ReorderLevel INT
    DECLARE @QuantityDiff INT

    -- Get current values from the OrderDetails table
    SELECT @CurrentUnitPrice = UnitPrice, @CurrentQuantity = Quantity, @CurrentDiscount = Discount
    FROM OrderDetails
    WHERE OrderID = @OrderID AND ProductID = @ProductID

    -- Use ISNULL to retain original values if new values are not provided
    SET @UnitPrice = ISNULL(@UnitPrice, @CurrentUnitPrice)
    SET @Quantity = ISNULL(@Quantity, @CurrentQuantity)
    SET @Discount = ISNULL(@Discount, @CurrentDiscount)

    -- Calculate quantity difference
    SET @QuantityDiff = @Quantity - @CurrentQuantity

    -- Check stock levels
    SELECT @UnitsInStock = UnitsInStock, @ReorderLevel = ReorderLevel
    FROM Product
    WHERE ProductID = @ProductID

    IF @UnitsInStock < @QuantityDiff
    BEGIN
        PRINT 'Failed to update the order. Not enough stock available.'
        RETURN
    END

    -- Update order details
    UPDATE OrderDetails
    SET UnitPrice = @UnitPrice, Quantity = @Quantity, Discount = @Discount
    WHERE OrderID = @OrderID AND ProductID = @ProductID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
    BEGIN
        PRINT 'Failed to update the order. Please try again.'
        RETURN
    END

    -- Update stock levels
    UPDATE Product
    SET UnitsInStock = UnitsInStock - @QuantityDiff
    WHERE ProductID = @ProductID

    -- Check if stock level is below reorder level
    IF @UnitsInStock - @QuantityDiff < @ReorderLevel
    BEGIN
        PRINT 'Warning: The quantity in stock of a product drops below its reorder level.'
    END

CREATE PROCEDURE GetOrderDetails
    @OrderID INT
AS
BEGIN
    -- Get order details
    IF EXISTS (SELECT * FROM OrderDetails WHERE OrderID = @OrderID)
    BEGIN
        SELECT * FROM OrderDetails WHERE OrderID = @OrderID
    END
    ELSE
    BEGIN
        PRINT 'The OrderID ' + CAST(@OrderID AS VARCHAR(10)) + ' does not exist.'
        RETURN 1
    END
END

END


CREATE FUNCTION FormatDate_MMDDYYYY (@inputDate DATETIME)
RETURNS VARCHAR(10)
AS
BEGIN
    RETURN (SELECT CONVERT(VARCHAR(10), @inputDate, 101))
END

CREATE FUNCTION FormatDate_YYYYMMDD (@inputDate DATETIME)
RETURNS VARCHAR(8)
AS
BEGIN
    RETURN (SELECT CONVERT(VARCHAR(8), @inputDate, 112))
END

CREATE VIEW vwCustomerOrders AS
SELECT 
    c.CompanyName,
    o.OrderID,
    o.OrderDate,
    od.ProductID,
    p.ProductName,
    od.Quantity,
    od.UnitPrice,
    (od.Quantity * od.UnitPrice) AS TotalPrice
FROM 
    Orders o
JOIN 
    Customers c ON o.CustomerID = c.CustomerID
JOIN 
    [Order Details] od ON o.OrderID = od.OrderID
JOIN 
    Products p ON od.ProductID = p.ProductID



CREATE VIEW vwCustomerOrders_Yesterday AS
SELECT 
    c.CompanyName,
    o.OrderID,
    o.OrderDate,
    od.ProductID,
    p.ProductName,
    od.Quantity,
    od.UnitPrice,
    (od.Quantity * od.UnitPrice) AS TotalPrice
FROM 
    Orders o
JOIN 
    Customers c ON o.CustomerID = c.CustomerID
JOIN 
    [Order Details] od ON o.OrderID = od.OrderID
JOIN 
    Products p ON od.ProductID = p.ProductID
WHERE 
    CAST(o.OrderDate AS DATE) = CAST(DATEADD(DAY, -1, GETDATE()) AS DATE)



CREATE VIEW MyProducts AS
SELECT 
    p.ProductID,
    p.ProductName,
    p.QuantityPerUnit,
    p.UnitPrice,
    s.CompanyName,
    c.CategoryName
FROM 
    Products p
JOIN 
    Suppliers s ON p.SupplierID = s.SupplierID
JOIN 
    Categories c ON p.CategoryID = c.CategoryID

