USE master;
IF EXISTS (SELECT * FROM sys.databases WHERE name = 'EventEaseDB_ST10471193')
DROP DATABASE EventEaseDB_ST10471193;
CREATE DATABASE EventEaseDB_ST10471193;

USE EventEaseDB_ST10471193;

-- Venue Table
CREATE TABLE Venue (
    VenueID INT IDENTITY(1,1) PRIMARY KEY,
    VenueName NVARCHAR(255) NOT NULL,
    Location NVARCHAR(255) NOT NULL,
    Capacity INT NOT NULL CHECK (Capacity > 0),
    ImageUrl NVARCHAR(500) NULL
);

-- Event Table
CREATE TABLE Event (
    EventID INT IDENTITY(1,1) PRIMARY KEY,
    EventName NVARCHAR(255) NOT NULL,
    EventDate DATETIME NOT NULL,
    Description NVARCHAR(1000) NULL,
    VenueID INT NULL, -- Venue may not be assigned initially
    FOREIGN KEY (VenueID) REFERENCES Venue(VenueID) ON DELETE SET NULL
);

-- Booking Table
CREATE TABLE Booking (
    BookingID INT IDENTITY(1,1) PRIMARY KEY,
    EventID INT NOT NULL,
    VenueID INT NOT NULL,
    BookingDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (EventID) REFERENCES Event(EventID) ON DELETE CASCADE,
    FOREIGN KEY (VenueID) REFERENCES Venue(VenueID) ON DELETE CASCADE,
    CONSTRAINT UQ_Venue_Event UNIQUE (VenueID, EventID) -- Prevents double booking of the same venue for the same event
);

-- Ensure no two bookings overlap for the same venue
CREATE UNIQUE INDEX UQ_Venue_Booking ON Booking (VenueID, BookingDate);

-- Insert data into Venue table
INSERT INTO Venue (VenueName, Location, Capacity, ImageUrl)
VALUES 
('Crystal Ballroom', '45 Sandton Drive, Johannesburg', 500, 'https://example.com/images/crystal_ballroom.jpg'),
('Ocean Breeze Venue', '18 Marine Parade, Durban', 200, 'https://example.com/images/ocean_breeze.jpg'),
('Mountain View Lodge', '72 Highland Road, Pretoria', 150, 'https://example.com/images/mountain_view.jpg'),
('Sunset Terrace Hall', '9 Sunset Avenue, Cape Town', 350, 'https://example.com/images/sunset_terrace.jpg'),
('Willow Garden Estate', '33 Willow Lane, Stellenbosch', 100, 'https://example.com/images/willow_garden.jpg');

-- Insert data into Event table
INSERT INTO Event (EventName, EventDate, Description, VenueID)
VALUES 
('Startup Innovation Summit', '2025-10-10 09:00:00', 'A summit for startups and entrepreneurs to showcase new ideas.', 1),
('Smith Family Wedding Reception', '2025-11-15 17:30:00', 'Wedding reception celebrating the union of Emma and Daniel Smith.', 2),
('Leadership Development Workshop', '2025-12-05 13:00:00', 'Workshop focusing on leadership and team management skills.', 3),
('Summer Music Festival', '2026-01-20 18:00:00', 'Outdoor music festival with live bands and entertainment.', 4),
('Charity Garden Luncheon', '2026-02-14 12:00:00', 'Fundraising luncheon supporting local community charities.', 5);

-- Insert data into Booking table
INSERT INTO Booking (EventID, VenueID, BookingDate)
VALUES 
(1, 1, '2025-10-01 10:30:00'),
(2, 2, '2025-11-01 11:45:00'),
(3, 3, '2025-11-20 09:15:00'),
(4, 4, '2025-12-15 14:00:00'),
(5, 5, '2026-01-10 13:20:00');

SELECT * FROM Venue;
SELECT * FROM Event;
SELECT * FROM Booking;