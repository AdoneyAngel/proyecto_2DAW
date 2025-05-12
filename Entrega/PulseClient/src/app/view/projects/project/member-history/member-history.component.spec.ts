import { ComponentFixture, TestBed } from '@angular/core/testing';

import { MemberHistoryComponent } from './member-history.component';

describe('MemberHistoryComponent', () => {
  let component: MemberHistoryComponent;
  let fixture: ComponentFixture<MemberHistoryComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [MemberHistoryComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(MemberHistoryComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
