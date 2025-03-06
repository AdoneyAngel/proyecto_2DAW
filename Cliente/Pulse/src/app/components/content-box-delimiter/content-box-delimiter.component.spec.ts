import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ContentBoxDelimiterComponent } from './content-box-delimiter.component';

describe('ContentBoxDelimiterComponent', () => {
  let component: ContentBoxDelimiterComponent;
  let fixture: ComponentFixture<ContentBoxDelimiterComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [ContentBoxDelimiterComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(ContentBoxDelimiterComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
