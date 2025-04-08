import { ComponentFixture, TestBed } from '@angular/core/testing';

import { AddUserPasswordComponent } from './add-user-password.component';

describe('AddUserPasswordComponent', () => {
  let component: AddUserPasswordComponent;
  let fixture: ComponentFixture<AddUserPasswordComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [AddUserPasswordComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(AddUserPasswordComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
