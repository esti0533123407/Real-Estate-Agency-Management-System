Real Estate Agency Management System
Project Overview
This project is a full-stack application developed as a preparation project for the practicum course.

The system manages real estate properties, agents, and the selling/renting process of apartments.

The architecture follows a three-layer structure:

Angular Client → .NET Web API → SQL Server Database

All communication with the database is performed using Stored Procedures only, as required by the project instructions.

Technologies
Database
SQL Server

Server Side
.NET Web API (C#)

Client Side
Angular

System Architecture
The system is built using three layers:

Client (Angular)
Handles UI, routing, forms, and API communication.

API (.NET Web API)
Receives requests from Angular and executes stored procedures.

Database (SQL Server)
Stores all system data and contains the stored procedures.

Flow of the system:

Angular → API → SQL Server → API → Angular

Database Structure
The database contains four main tables.

Apartments (Main Table)
Stores the real estate properties.

Fields:

ApartmentID
Title
Description
Price
CityID
StatusID
AgentID
CreatedDate
Relationships:

CityID → Cities table
StatusID → Statuses table
AgentID → Agents table
Cities
Stores the list of cities.

Fields:

CityID
CityName
Statuses
Stores property status values.

Examples:

For Sale
For Rent
Sold
Fields:

StatusID
StatusName
Agents
Stores the real estate agents.

Fields:

AgentID
FullName
Email
Stored Procedures
All database operations are implemented through stored procedures.

Main procedures:

CreateApartment
Creates a new property.

UpdateApartment
Updates an existing property.

GetApartmentById
Returns full details of a specific property including joined information.

GetAllApartments
Returns the list of all properties with search and filters.

DeleteApartment
Deletes a property.

Additional procedures:

GetAllCities
Returns city list.

GetAllStatuses
Returns status list.

GetAllAgents
Returns agents list.

GetApartmentsByAgent
Returns properties belonging to a specific agent.

API
The API contains a single endpoint as required by the project instructions.

POST /api/exec

The request contains:

procedureName
parameters

Example request: