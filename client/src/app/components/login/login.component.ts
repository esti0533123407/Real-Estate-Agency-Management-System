import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router, RouterModule } from '@angular/router';
import { DataService } from '../../services/data.service';
import { AuthService } from '../../services/auth.service';
import { Agent } from '../../models/agent.model';


@Component({
  selector: 'app-login',
  standalone: true,
 imports: [CommonModule, FormsModule, RouterModule],
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss']
})
export class LoginComponent implements OnInit {
  agentEmail: string = '';
  agents: Agent[] = [];

  constructor(
    private dataService: DataService,
    private authService: AuthService,
    private router: Router
  ) {}

  ngOnInit(): void {
    this.loadAgents();
  }

  loadAgents(): void {
    this.dataService.execute('GetAllAgents').subscribe({
      next: (data) => {
        console.log('Agents loaded:', data);
        this.agents = data;
      },
      error: (err) => {
        console.error('שגיאה בטעינת הסוכנים:', err);
      }
    });
  }

  login(): void {
    const email = this.agentEmail.trim().toLowerCase();

    console.log('Entered email:', email);

    if (!email) {
      alert('יש להזין מייל');
      return;
    }

    const agent = this.agents.find(
      a => (a.Email || '').trim().toLowerCase() === email
    );

    console.log('Matched agent:', agent);

    if (!agent) {
      alert('המייל לא נמצא במערכת');
      return;
    }

    this.authService.loginAsAgent(agent.AgentID, agent.FullName);

    console.log('Logged in as agent:', agent.AgentID, agent.FullName);

    this.router.navigate(['/']).then(success => {
      console.log('Navigation success:', success);
    });
  }
}