export interface Apartment {
  ApartmentID: number;
  Title: string;
  Description: string;
  Price: number;
  CityID: number;
  StatusID: number;
  AgentID: number;
  CreatedDate: Date;
  ImageUrl?: string;
  CityName?: string;
  StatusName?: string;
  AgentName?: string;
}

