import { HttpClient } from '@angular/common/http';
import { TestBed } from '@angular/core/testing';
import { EmployeeService } from './employee.service';

import {HttpClientTestingModule, HttpTestingController} from '@angular/common/http/testing';
import { Department } from '../models/department';
import { departmentsList, employeesList } from '../sample_data/data';
import { Employee } from '../models/employee';

describe('EmployeeService', () => {
  let service: EmployeeService;
  let http: HttpClient;
  let httpTestCtrl: HttpTestingController;
  let departments:Department[] = departmentsList;
  let employees: Employee[]=employeesList;

  beforeEach(() => {
    TestBed.configureTestingModule({
      imports: [HttpClientTestingModule],
    });
    service = TestBed.inject(EmployeeService);
    http = TestBed.inject(HttpClient);
    httpTestCtrl = TestBed.inject(HttpTestingController);
  });

  afterEach(()=>{
    httpTestCtrl.verify();
  });


  it('should be created', () => {
    expect(service).toBeTruthy();
  });

  //testcase for getting all the departments
  it('should be able to fetch all the departments records', () => {
    service.getAllDepartments().subscribe((data) => {
      expect(data).toBeTruthy();
    });
    const apiIURL = httpTestCtrl.expectOne('http://localhost:8080/ems/departmentslist');
    expect(apiIURL.request.method).toEqual('GET');
    expect(apiIURL.request.responseType).toEqual('json');

    apiIURL.flush(departments);
  });

  //testcase for getting all the employees
  it('should be able to fetch all the employees records', () => {
    service.getAllEmployees().subscribe((data) => {
      expect(data).toBeTruthy();
    });
    const apiIURL = httpTestCtrl.expectOne('http://localhost:8080/ems/employeeslist');
    expect(apiIURL.request.method).toEqual('GET');
    expect(apiIURL.request.responseType).toEqual('json');

    apiIURL.flush(employees);
  });

  //testcase for adding new employee
  it('should be able to add new employee into the database', ()=>{
    let newEmployee:Employee ={
      "employeeId":1022,
      "firstName":"Nithya",
      "lastName":"Kumari",
      "dateOfBirth":"2019-12-12T00:00:00.000+00:00",
      "contactNo":90976432343,
      "department":
      {
          "departmentId":1,
          "deprtmentName":"HR"
      }
    };
    service.createEmployee(newEmployee).subscribe((data) =>{
      expect(data).toEqual(newEmployee);
    });

    const apiIURL = httpTestCtrl.expectOne('http://localhost:8080/ems/add-employee');
    expect(apiIURL.request.responseType).toEqual('json');
    expect(apiIURL.request.method).toEqual('POST');


    apiIURL.flush(newEmployee);

  });

  //testcase for adding new department
  it('should be able to add new department into the database', ()=>{
    let newDepartment:Department ={
          "departmentId":25,
          "deprtmentName":"Service"
    };
    service.createDepartment(newDepartment).subscribe((data) =>{
      expect(data).toEqual(newDepartment);
    });

    const apiIURL = httpTestCtrl.expectOne('http://localhost:8080/ems/adddepartment');
    expect(apiIURL.request.responseType).toEqual('json');
    expect(apiIURL.request.method).toEqual('POST');


    apiIURL.flush(newDepartment);

  });

   //testcase for searching employee by employeeId
   it('should be able to get details of the employee by using employeeId', ()=>{
    let employee:Employee ={
      "employeeId":1019,
      "firstName":"Rakshith",
      "lastName":"Manjunathu",
      "dateOfBirth":"2000-04-07T00:00:00.000+00:00",
      "contactNo":909764323456,
      "department":
      {
          "departmentId":21,
          "deprtmentName":"xyz"
      }
    };
    service.getEmployee(employee.employeeId).subscribe((data) =>{
      expect(data).toEqual(employee);
    });

    const apiIURL = httpTestCtrl.expectOne('http://localhost:8080/ems/employeebyid/1019');
    expect(apiIURL.request.responseType).toEqual('json');
    expect(apiIURL.request.method).toEqual('GET');


    apiIURL.flush(employee);

  });

  //testcase for update employee details with the help of employeeId
  it('should be able to update details of the employee by using employeeId', ()=>{
    let employee:Employee ={
      "employeeId":1019,
      "firstName":"Rakshith",
      "lastName":"Manjunat",
      "dateOfBirth":"2000-04-07T00:00:00.000+00:00",
      "contactNo":90976412345,
      "department":
      {
          "departmentId":21,
          "deprtmentName":"xyz"
      }
    };
    service.updateEmployee(employee.employeeId, employee).subscribe((data) =>{
      expect(data).toEqual(employee);
    });

    const apiIURL = httpTestCtrl.expectOne('http://localhost:8080/ems/edit-employee/1019');
    expect(apiIURL.request.responseType).toEqual('json');
    expect(apiIURL.request.method).toEqual('PUT');


    apiIURL.flush(employee);

  });
});