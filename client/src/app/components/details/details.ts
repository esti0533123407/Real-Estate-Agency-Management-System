import { Component, OnInit, ChangeDetectorRef } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { DataService } from '../../services/data.service';
import { Apartment } from '../../models/apartment.model';
import { CommonModule, Location } from '@angular/common';

@Component({
  selector: 'app-details',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './details.component.html',
  styleUrls: ['./details.component.scss']
})
export class DetailsComponent implements OnInit {
  apartment: Apartment | null = null;

  constructor(
    private route: ActivatedRoute,
    private dataService: DataService,
    private location: Location,
    private cdr: ChangeDetectorRef
  ) {}

  ngOnInit(): void {
    const id = this.route.snapshot.paramMap.get('id');

    if (id) {
      this.loadApartmentDetails(+id);
    }
  }

  goBack(): void {
    this.location.back();
  }

  loadApartmentDetails(id: number): void {
    this.dataService.execute('GetApartmentById', { ApartmentID: id }).subscribe({
      next: (data) => {
        console.log('GetApartmentById response:', data);
        this.apartment = data[0] || null;
        this.cdr.detectChanges();
      },
      error: (err) => {
        console.error('שגיאה בטעינת פרטי הדירה:', err);
      }
    });
  }
}