import { ComponentFixture, TestBed } from '@angular/core/testing';

import { LateralBarComponent } from './lateral-bar.component';

describe('LateralBarComponent', () => {
  let component: LateralBarComponent;
  let fixture: ComponentFixture<LateralBarComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [LateralBarComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(LateralBarComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
