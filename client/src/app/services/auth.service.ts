import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class AuthService {

  loginAsCustomer(): void {
    localStorage.setItem('role', 'customer');
    localStorage.removeItem('agentId');
    localStorage.removeItem('agentName');
  }

  loginAsAgent(agentId: number, agentName: string): void {
    localStorage.setItem('role', 'agent');
    localStorage.setItem('agentId', agentId.toString());
    localStorage.setItem('agentName', agentName);
  }

  logout(): void {
    localStorage.removeItem('role');
    localStorage.removeItem('agentId');
    localStorage.removeItem('agentName');
  }

  getRole(): string | null {
    return localStorage.getItem('role');
  }

  getAgentId(): number | null {
    const value = localStorage.getItem('agentId');
    return value ? +value : null;
  }

  getAgentName(): string | null {
    return localStorage.getItem('agentName');
  }

  isCustomer(): boolean {
    return this.getRole() === 'customer';
  }

  isAgent(): boolean {
    return this.getRole() === 'agent';
  }

  isLoggedIn(): boolean {
    return !!this.getRole();
  }
}