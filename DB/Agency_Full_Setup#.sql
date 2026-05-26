CREATE TABLE Cities (
    CityID INT PRIMARY KEY IDENTITY(1,1),
    CityName NVARCHAR(50) NOT NULL
);

CREATE TABLE Statuses (
    StatusID INT PRIMARY KEY IDENTITY(1,1),
    StatusName NVARCHAR(50) NOT NULL
);
CREATE TABLE Agents (
    AgentID INT PRIMARY KEY IDENTITY(1,1),
    FullName NVARCHAR(100) NOT NULL,
    Phone NVARCHAR(20) NOT NULL,
    Email NVARCHAR(100)
);

CREATE TABLE Apartments (
    ApartmentID INT PRIMARY KEY IDENTITY(1,1),
    Title NVARCHAR(100) NOT NULL,
    Description NVARCHAR(MAX),
    Price DECIMAL(18,2),
    CityID INT FOREIGN KEY REFERENCES Cities(CityID),
    StatusID INT FOREIGN KEY REFERENCES Statuses(StatusID),
    AgentID INT FOREIGN KEY REFERENCES Agents(AgentID),
    CreatedDate DATETIME DEFAULT GETDATE()
);

CREATE PROCEDURE GetAllApartments
    @SearchText NVARCHAR(100) = NULL
AS
BEGIN
    SELECT a.*, c.CityName, s.StatusName, ag.FullName AS AgentName
    FROM Apartments a
    JOIN Cities c ON a.CityID = c.CityID
    JOIN Statuses s ON a.StatusID = s.StatusID
    LEFT JOIN Agents ag ON a.AgentID = ag.AgentID
    WHERE (@SearchText IS NULL OR a.Title LIKE '%' + @SearchText + '%' OR a.Description LIKE '%' + @SearchText + '%')
END
GO

CREATE PROCEDURE GetApartmentById
    @ApartmentID INT
AS
BEGIN
    SELECT a.*, c.CityName, s.StatusName, ag.FullName AS AgentName, ag.Phone AS AgentPhone
    FROM Apartments a
    JOIN Cities c ON a.CityID = c.CityID
    JOIN Statuses s ON a.StatusID = s.StatusID
    LEFT JOIN Agents ag ON a.AgentID = ag.AgentID
    WHERE a.ApartmentID = @ApartmentID
END
GO

CREATE PROCEDURE CreateApartment
    @Title NVARCHAR(100), @Description NVARCHAR(MAX), @Price DECIMAL(18,2),
    @CityID INT, @StatusID INT, @AgentID INT
AS
BEGIN
    INSERT INTO Apartments (Title, Description, Price, CityID, StatusID, AgentID)
    VALUES (@Title, @Description, @Price, @CityID, @StatusID, @AgentID)
END
GO

CREATE PROCEDURE UpdateApartment
    @ApartmentID INT, @Title NVARCHAR(100), @Description NVARCHAR(MAX), 
    @Price DECIMAL(18,2), @CityID INT, @StatusID INT, @AgentID INT
AS
BEGIN
    UPDATE Apartments 
    SET Title = @Title, Description = @Description, Price = @Price, 
        CityID = @CityID, StatusID = @StatusID, AgentID = @AgentID
    WHERE ApartmentID = @ApartmentID
END
GO

CREATE PROCEDURE DeleteApartment
    @ApartmentID INT
AS
BEGIN
    DELETE FROM Apartments WHERE ApartmentID = @ApartmentID
END
GO

INSERT INTO Cities (CityName) VALUES 
('New York, NY'), 
('Los Angeles, CA'), 
('Miami, FL'), 
('Chicago, IL'), 
('Houston, TX'), 
('Phoenix, AZ'), 
('Las Vegas, NV');

INSERT INTO Statuses (StatusName) VALUES 
('For Sale'), 
('For Rent'), 
('Under Contract'), 
('Sold');

INSERT INTO Agents (FullName, Phone, Email) VALUES 
('Michael Smith', '212-555-0198', 'm.smith@agency.com'),
('Sarah Johnson', '310-555-0432', 's.johnson@agency.com'),
('Robert Davis', '786-555-0761', 'r.davis@agency.com'),
('Linda Wilson', '312-555-0912', 'l.wilson@agency.com');

INSERT INTO Apartments (Title, Description, Price, CityID, StatusID, AgentID) VALUES 
('Luxury Manhattan Penthouse', 'Stunning 3-bedroom penthouse with Central Park views.', 4500000, 1, 1, 1),
('Beachfront Miami Condo', 'Modern 2-bedroom condo with direct ocean access.', 1200000, 3, 1, 3),
('Downtown Chicago Loft', 'Industrial style loft in the heart of the Loop.', 5500, 4, 2, 4),
('Beverly Hills Mansion', 'Exclusive estate with private pool and cinema room.', 12500000, 2, 1, 2),
('Modern Houston Suburban Home', 'Spacious 4-bedroom home in a quiet neighborhood.', 450000, 5, 1, 4),
('Phoenix Desert Villa', 'Beautiful villa with mountain views and xeriscaping.', 850000, 6, 3, 1),
('Las Vegas Strip Apartment', 'High-rise studio with views of the fountains.', 3200, 7, 2, 2),
('Brooklyn Brownstone', 'Classic renovated townhouse with private garden.', 2800000, 1, 4, 1),
('Santa Monica Studio', 'Steps away from the beach, perfect for young professionals.', 3800, 2, 2, 2),
('Miami Design District Townhouse', 'Chic 3-level townhouse near high-end shops.', 950000, 3, 1, 3);


EXEC CreateApartment 
    @Title = 'Luxury Test Villa', 
    @Description = 'A test property for our agency', 
    @Price = 1500000, 
    @CityID = 1,     
    @StatusID = 1,   
    @AgentID = 1;   

	EXEC GetAllApartments;

	EXEC GetApartmentById @ApartmentID = 11;
EXEC UpdateApartment 
    @ApartmentID = 11, 
    @Title = 'Updated Luxury Villa', 
    @Description = 'Updated description after price drop', 
    @Price = 1450000, 
    @CityID = 1, 
    @StatusID = 1, 
    @AgentID = 1;

EXEC GetApartmentById @ApartmentID = 11;
EXEC GetAllApartments @SearchText = 'Updated';
EXEC DeleteApartment @ApartmentID = 11;
EXEC GetApartmentById @ApartmentID = 11;


USE RealEstate_Agency
GO

CREATE OR ALTER PROCEDURE GetAllCities
AS
BEGIN
    SELECT  CityID,
            CityName
    FROM Cities
    ORDER BY  CityName
END
GO

CREATE PROCEDURE GetAllStatuses
AS
BEGIN
    SELECT StatusID, StatusName
    FROM Statuses
    ORDER BY StatusName
END
GO

CREATE PROCEDURE GetAllAgents
AS
BEGIN
    SELECT AgentID, FullName
    FROM Agents
    ORDER BY FullName
END
GO

EXEC GetAllCities
EXEC GetAllStatuses
EXEC GetAllAgents

ALTER TABLE Apartments
ADD ImageUrl NVARCHAR(500) NULL;

ALTER PROCEDURE [dbo].[GetAllApartments]
    @SearchText NVARCHAR(100) = NULL,
    @CityID INT = NULL,
    @StatusID INT = NULL,
    @MinPrice DECIMAL(18,2) = NULL,
    @MaxPrice DECIMAL(18,2) = NULL
AS
BEGIN
    SELECT
        A.ApartmentID,
        A.Title,
        A.Description,
        A.Price,
        A.CityID,
        A.StatusID,
        A.AgentID,
        A.CreatedDate,
        A.ImageUrl,
        C.CityName,
        S.StatusName,
        Ag.FullName AS AgentName
    FROM Apartments A
    JOIN Cities C ON A.CityID = C.CityID
    JOIN Statuses S ON A.StatusID = S.StatusID
    JOIN Agents Ag ON A.AgentID = Ag.AgentID
    WHERE
        (@SearchText IS NULL OR A.Title LIKE '%' + @SearchText + '%')
        AND (@CityID IS NULL OR A.CityID = @CityID)
        AND (@StatusID IS NULL OR A.StatusID = @StatusID)
        AND (@MinPrice IS NULL OR A.Price >= @MinPrice)
        AND (@MaxPrice IS NULL OR A.Price <= @MaxPrice)
    ORDER BY A.CreatedDate DESC
END

ALTER PROCEDURE [dbo].[GetAllApartments]
    @SearchText NVARCHAR(100) = NULL,
    @CityID INT = NULL,
    @StatusID INT = NULL,
    @MinPrice DECIMAL(18,2) = NULL,
    @MaxPrice DECIMAL(18,2) = NULL
AS
BEGIN
    SELECT
        A.ApartmentID,
        A.Title,
        A.Description,
        A.Price,
        A.CityID,
        A.StatusID,
        A.AgentID,
        A.CreatedDate,
        A.ImageUrl,
        C.CityName,
        S.StatusName,
        Ag.FullName AS AgentName
    FROM Apartments A
    JOIN Cities C ON A.CityID = C.CityID
    JOIN Statuses S ON A.StatusID = S.StatusID
    JOIN Agents Ag ON A.AgentID = Ag.AgentID
    WHERE
        (@SearchText IS NULL OR A.Title LIKE '%' + @SearchText + '%')
        AND (@CityID IS NULL OR A.CityID = @CityID)
        AND (@StatusID IS NULL OR A.StatusID = @StatusID)
        AND (@MinPrice IS NULL OR A.Price >= @MinPrice)
        AND (@MaxPrice IS NULL OR A.Price <= @MaxPrice)
    ORDER BY A.CreatedDate DESC
END


ALTER PROCEDURE [dbo].[GetApartmentsByAgent]
    @AgentID INT,
    @SearchText NVARCHAR(100) = NULL,
    @CityID INT = NULL,
    @StatusID INT = NULL,
    @MinPrice DECIMAL(18,2) = NULL,
    @MaxPrice DECIMAL(18,2) = NULL
AS
BEGIN
    SELECT
        A.ApartmentID,
        A.Title,
        A.Description,
        A.Price,
        A.CityID,
        A.StatusID,
        A.AgentID,
        A.CreatedDate,
        A.ImageUrl,
        C.CityName,
        S.StatusName,
        Ag.FullName AS AgentName
    FROM Apartments A
    JOIN Cities C ON A.CityID = C.CityID
    JOIN Statuses S ON A.StatusID = S.StatusID
    JOIN Agents Ag ON A.AgentID = Ag.AgentID
    WHERE
        A.AgentID = @AgentID
        AND (@SearchText IS NULL OR A.Title LIKE '%' + @SearchText + '%')
        AND (@CityID IS NULL OR A.CityID = @CityID)
        AND (@StatusID IS NULL OR A.StatusID = @StatusID)
        AND (@MinPrice IS NULL OR A.Price >= @MinPrice)
        AND (@MaxPrice IS NULL OR A.Price <= @MaxPrice)
    ORDER BY A.CreatedDate DESC
END

ALTER PROCEDURE [dbo].[GetApartmentById]
    @ApartmentID INT
AS
BEGIN
    SELECT
        a.ApartmentID,
        a.Title,
        a.Description,
        a.Price,
        a.CityID,
        a.StatusID,
        a.AgentID,
        a.CreatedDate,
        a.ImageUrl,
        c.CityName,
        s.StatusName,
        ag.FullName AS AgentName,
        ag.Phone AS AgentPhone
    FROM Apartments a
    JOIN Cities c ON a.CityID = c.CityID
    JOIN Statuses s ON a.StatusID = s.StatusID
    LEFT JOIN Agents ag ON a.AgentID = ag.AgentID
    WHERE a.ApartmentID = @ApartmentID
END

ALTER PROCEDURE [dbo].[CreateApartment]
    @Title NVARCHAR(100),
    @Description NVARCHAR(MAX),
    @Price DECIMAL(18,2),
    @CityID INT,
    @StatusID INT,
    @AgentID INT,
    @ImageUrl NVARCHAR(500) = NULL
AS
BEGIN
    INSERT INTO Apartments
    (
        Title,
        Description,
        Price,
        CityID,
        StatusID,
        AgentID,
        ImageUrl
    )
    VALUES
    (
        @Title,
        @Description,
        @Price,
        @CityID,
        @StatusID,
        @AgentID,
        @ImageUrl
    )
END

ALTER PROCEDURE [dbo].[UpdateApartment]
    @ApartmentID INT,
    @Title NVARCHAR(100),
    @Description NVARCHAR(MAX),
    @Price DECIMAL(18,2),
    @CityID INT,
    @StatusID INT,
    @AgentID INT,
    @ImageUrl NVARCHAR(500) = NULL
AS
BEGIN
    UPDATE Apartments
    SET
        Title = @Title,
        Description = @Description,
        Price = @Price,
        CityID = @CityID,
        StatusID = @StatusID,
        AgentID = @AgentID,
        ImageUrl = @ImageUrl
    WHERE ApartmentID = @ApartmentID
END


UPDATE Apartments SET ImageUrl = 'assets/Image/1.jpg' WHERE ApartmentID = 1;
UPDATE Apartments SET ImageUrl = 'assets/Image/2.jpg' WHERE ApartmentID = 2;
UPDATE Apartments SET ImageUrl = 'assets/Image/3.jpg' WHERE ApartmentID = 3;
UPDATE Apartments SET ImageUrl = 'assets/Image/4.jpg' WHERE ApartmentID = 4;
UPDATE Apartments SET ImageUrl = 'assets/Image/5.jpg' WHERE ApartmentID = 5;
UPDATE Apartments SET ImageUrl = 'assets/Image/6.jpg' WHERE ApartmentID = 6;
UPDATE Apartments SET ImageUrl = 'assets/Image/7.jpg' WHERE ApartmentID = 7;
UPDATE Apartments SET ImageUrl = 'assets/Image/8.jpg' WHERE ApartmentID = 8;
UPDATE Apartments SET ImageUrl = 'assets/Image/9.jpg' WHERE ApartmentID = 9;
UPDATE Apartments SET ImageUrl = 'assets/Image/10.jpg' WHERE ApartmentID = 10;
UPDATE Apartments SET ImageUrl = 'assets/Image/11.jpg' WHERE ApartmentID = 11;
UPDATE Apartments SET ImageUrl = 'assets/Image/12.jpg' WHERE ApartmentID = 12;