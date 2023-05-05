package com.mit;

public class Student_probationBean {
    int student_id;
    int probation_year;
    String probation_quarter;
    String probation_reason;

    public int getStudent_id() {
		return student_id;
	}
	public void setStudent_id(int student_id) {
		this.student_id = student_id;
	}

    public int getProbation_year() {
        return probation_year;
    }

    public void setProbation_year(int probation_year) {
        this.probation_year = probation_year;
    }

    public String getProbation_quarter() {
        return probation_quarter;
    }

    public void setProbation_quarter(String probation_quarter) {
        this.probation_quarter = probation_quarter;
    }

    public String getProbation_reason() {
        return probation_reason;
    }

    public void setProbation_reason(String probation_reason) {
        this.probation_reason = probation_reason;
    }
}
