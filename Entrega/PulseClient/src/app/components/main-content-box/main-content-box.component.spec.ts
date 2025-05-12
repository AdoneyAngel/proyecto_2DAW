import { ComponentFixture, TestBed } from '@angular/core/testing';

import { MainContentBoxComponent } from './main-content-box.component';

describe('MainContentBoxComponent', () => {
  let component: MainContentBoxComponent;
  let fixture: ComponentFixture<MainContentBoxComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [MainContentBoxComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(MainContentBoxComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
