package com.mit;

public class Courses_takenBean {
    int student_id;
    String course_number;
    String section_id;
    int year;
    int unit;
    String grade;
    String professor;

    public int getStudent_id() {
		return student_id;
	}
	public void setStudent_id(int student_id) {
		this.student_id = student_id;
	}

    public String getCourse_number() {
        return this.course_number;
    }

    public void setCourse_number(String course_number) {
        this.course_number = course_number;
    }

    public String getSection_id() {
        return this.section_id;
    }

    public void setSection_id(String section_id) {
        this.section_id = section_id;
    }
   
    public int getYear() {
        return this.year;
    }

    public void setYear(int year) {
        this.year = year;
    }

    public int getUnit() {
        return this.unit;
    }

    public void setUnit(int unit) {
        this.unit = unit;
    }

    public String getGrade() {
        return this.grade;
    }

    public void setGrade(String grade) {
        this.grade = grade;
    }
    
    public String getProfessor() {
        return this.professor;
    }

    public void setProfessor(String professor) {
        this.professor = professor;
    }
}
