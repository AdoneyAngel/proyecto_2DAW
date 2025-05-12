import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ContentBoxSimpleDelimiterComponent } from './content-box-simple-delimiter.component';

describe('ContentBoxSimpleDelimiterComponent', () => {
  let component: ContentBoxSimpleDelimiterComponent;
  let fixture: ComponentFixture<ContentBoxSimpleDelimiterComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [ContentBoxSimpleDelimiterComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(ContentBoxSimpleDelimiterComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
