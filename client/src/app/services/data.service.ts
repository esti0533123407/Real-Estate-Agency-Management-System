import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class DataService {
  private apiUrl = 'http://localhost:5017/api/exec';

  constructor(private http: HttpClient) {}

  execute(procedureName: string, parameters: any = {}): Observable<any[]> {
    const requestBody = {
      procedureName: procedureName,
      parameters: parameters
    };

    console.log('Request body:', requestBody);

    return this.http.post<any[]>(this.apiUrl, requestBody);
  }
}