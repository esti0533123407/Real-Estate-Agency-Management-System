import { Component, OnInit, ChangeDetectorRef } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormBuilder, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
import { ActivatedRoute, Router, RouterModule } from '@angular/router';
import { DataService } from '../../services/data.service';
import { City } from '../../models/city.model';
import { Status } from '../../models/status.model';
import { Agent } from '../../models/agent.model';

@Component({
  selector: 'app-edit-form',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule, RouterModule],
  templateUrl: './edit-form.component.html',
  styleUrls: ['./edit-form.component.scss']
})
export class EditFormComponent implements OnInit {
  apartmentForm!: FormGroup;

  isEditMode = false;
  apartmentId: number | null = null;
  isLoading = false;

  cities: City[] = [];
  statuses: Status[] = [];
  agents: Agent[] = [];

  constructor(
    private fb: FormBuilder,
    private dataService: DataService,
    private route: ActivatedRoute,
    private router: Router,
    private cdr: ChangeDetectorRef
  ) {}

  ngOnInit(): void {
    this.createForm();
    this.loadLookupData();

    const id = this.route.snapshot.paramMap.get('id');
    if (id) {
      this.isEditMode = true;
      this.apartmentId = +id;
      this.loadApartmentById(this.apartmentId);
    }
  }

  createForm(): void {
    this.apartmentForm = this.fb.group({
      Title: ['', [Validators.required, Validators.minLength(2)]],
      Description: ['', [Validators.required, Validators.minLength(5)]],
      Price: [null, [Validators.required, Validators.min(1)]],
      CityID: [null, Validators.required],
      StatusID: [null, Validators.required],
      AgentID: [null, Validators.required],
      ImageUrl: ['']
    });
  }

  loadLookupData(): void {
    this.dataService.execute('GetAllCities').subscribe({
      next: (data) => {
        this.cities = data;
        this.cdr.detectChanges();
      },
      error: (err) => console.error('שגיאה בטעינת ערים:', err)
    });

    this.dataService.execute('GetAllStatuses').subscribe({
      next: (data) => {
        this.statuses = data;
        this.cdr.detectChanges();
      },
      error: (err) => console.error('שגיאה בטעינת סטטוסים:', err)
    });

    this.dataService.execute('GetAllAgents').subscribe({
      next: (data) => {
        this.agents = data;
        this.cdr.detectChanges();
      },
      error: (err) => console.error('שגיאה בטעינת סוכנים:', err)
    });
  }

  loadApartmentById(id: number): void {
    this.isLoading = true;

    this.dataService.execute('GetApartmentById', { ApartmentID: id }).subscribe({
      next: (data) => {
        const apartment = data[0];

        if (apartment) {
          this.apartmentForm.patchValue({
            Title: apartment.Title,
            Description: apartment.Description,
            Price: apartment.Price,
            CityID: apartment.CityID,
            StatusID: apartment.StatusID,
            AgentID: apartment.AgentID,
            ImageUrl: apartment.ImageUrl
          });
        }

        this.isLoading = false;
        this.cdr.detectChanges();
      },
      error: (err) => {
        console.error('שגיאה בטעינת דירה לעריכה:', err);
        this.isLoading = false;
      }
    });
  }

  saveApartment(): void {
    if (this.apartmentForm.invalid) {
      this.apartmentForm.markAllAsTouched();
      return;
    }

    const formValue = this.apartmentForm.value;

    if (this.isEditMode && this.apartmentId) {
      const updateParams = {
        ApartmentID: this.apartmentId,
        Title: formValue.Title,
        Description: formValue.Description,
        Price: formValue.Price,
        CityID: formValue.CityID,
        StatusID: formValue.StatusID,
        AgentID: formValue.AgentID,
        ImageUrl: formValue.ImageUrl
      };

      this.dataService.execute('UpdateApartment', updateParams).subscribe({
        next: () => {
          alert('הדירה עודכנה בהצלחה');
          this.router.navigate(['/list']);
        },
        error: (err) => {
          console.error('שגיאה בעדכון דירה:', err);
        }
      });
    } else {
      const createParams = {
        Title: formValue.Title,
        Description: formValue.Description,
        Price: formValue.Price,
        CityID: formValue.CityID,
        StatusID: formValue.StatusID,
        AgentID: formValue.AgentID,
        ImageUrl: formValue.ImageUrl
      };

      this.dataService.execute('CreateApartment', createParams).subscribe({
        next: () => {
          alert('הדירה נוספה בהצלחה');
          this.router.navigate(['/list']);
        },
        error: (err) => {
          console.error('שגיאה בהוספת דירה:', err);
        }
      });
    }
  }

  cancel(): void {
    this.router.navigate(['/list']);
  }

  get f() {
    return this.apartmentForm.controls;
  }
}