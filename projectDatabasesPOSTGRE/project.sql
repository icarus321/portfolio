


CREATE TABLE Researcher(
    Email TEXT(),
    Name TEXT(),
    Phone TEXT(),
    Webpage TEXT(),
    Description TEXT(),
    Password TEXT(),
    PRIMARY KEY (Email),
    Department TEXT()
	
);

CREATE TABLE Authors(
    PMIDfor INT,
    Emailfor TEXT(),
    PRIMARY KEY (PMIDfor, Emailfor),
	FOREIGN KEY(Emailfor) REFERENCES Researcher(Email),
	FOREIGN KEY(PMIDfor) REFERENCES Medline.Article(PMID)	
);

CREATE TABLE Participating (
    
  ClinicalidFOR INT,
  Emailfor TEXT(),
  PRIMARY KEY(ClinicalidFOR, Emailfor),
  FOREIGN KEY(ClinicalidFOR) REFERENCES Clinical_Trials.clinical_study(id), 
  FOREIGN KEY(Emailfor) REFERENCES Researcher(Email) 
    
    
    
);
