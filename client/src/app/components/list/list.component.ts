import { Component, OnInit, ChangeDetectorRef } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule } from '@angular/router';
import { DataService } from '../../services/data.service';
import { Apartment } from '../../models/apartment.model';
import { AuthService } from '../../services/auth.service';
import { City } from '../../models/city.model';
import { Status } from '../../models/status.model';

@Component({
  selector: 'app-list',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterModule],
  templateUrl: './list.component.html',
  styleUrls: ['./list.component.scss']
})
export class ListComponent implements OnInit {

  apartments: Apartment[] = [];
  cities: City[] = [];
  statuses: Status[] = [];

  searchText: string = '';
  selectedCityId: number | null = null;
  selectedStatusId: number | null = null;
  minPrice: number | null = null;
  maxPrice: number | null = null;

  constructor(
    private dataService: DataService,
    private cdr: ChangeDetectorRef,
    public authService: AuthService
  ) {}

  ngOnInit(): void {
    this.loadLookupData();
    this.loadApartments();
  }

  loadLookupData(): void {
    this.dataService.execute('GetAllCities').subscribe({
      next: (data) => {
        this.cities = data;
        this.cdr.detectChanges();
      },
      error: (err) => {
        console.error('שגיאה בטעינת ערים:', err);
      }
    });

    this.dataService.execute('GetAllStatuses').subscribe({
      next: (data) => {
        this.statuses = data;
        this.cdr.detectChanges();
      },
      error: (err) => {
        console.error('שגיאה בטעינת סטטוסים:', err);
      }
    });
  }

  buildFilterParams(): any {
    return {
      SearchText: this.searchText?.trim() ? this.searchText.trim() : null,
      CityID: this.selectedCityId,
      StatusID: this.selectedStatusId,
      MinPrice: this.minPrice,
      MaxPrice: this.maxPrice
    };
  }

  loadApartments(): void {
    const params = this.buildFilterParams();

    if (this.authService.isAgent()) {
      const agentId = this.authService.getAgentId();

      this.dataService.execute(
        'GetApartmentsByAgent',
        {
          AgentID: agentId,
          ...params
        }
      ).subscribe({
        next: (data) => {
          this.apartments = data;
          this.cdr.detectChanges();
        },
        error: (err) => {
          console.error('שגיאה בטעינת הדירות של הסוכן:', err);
        }
      });

    } else {
      this.dataService.execute('GetAllApartments', params).subscribe({
        next: (data) => {
          this.apartments = data;
          this.cdr.detectChanges();
        },
        error: (err) => {
          console.error('שגיאה בטעינת הדירות:', err);
        }
      });
    }
  }

  onSearch(): void {
    this.loadApartments();
  }

  clearFilters(): void {
    this.searchText = '';
    this.selectedCityId = null;
    this.selectedStatusId = null;
    this.minPrice = null;
    this.maxPrice = null;
    this.loadApartments();
  }

  deleteApartment(apartmentId: number): void {
    const isConfirmed = confirm('האם את בטוחה שברצונך למחוק את הדירה?');

    if (!isConfirmed) {
      return;
    }

    this.dataService.execute(
      'DeleteApartment',
      { ApartmentID: apartmentId }
    ).subscribe({
      next: () => {
        alert('הדירה נמחקה בהצלחה');
        this.loadApartments();
      },
      error: (err) => {
        console.error('שגיאה במחיקת דירה:', err);
      }
    });
  }

  logout(): void {
    this.authService.logout();
    this.loadApartments();
  }
}
