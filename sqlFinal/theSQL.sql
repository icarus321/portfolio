USE<db_jlmadden>

CREATE TABLE UserAccounts(
	UserName VARCHAR(20) PRIMARY KEY,
	Password VARCHAR(20),
	CardNum VARCHAR(20),
	CardType VARCHAR(20)
);
CREATE TABLE Goods(
	ISBN VARCHAR(20) PRIMARY KEY,
	Price DECIMAL(6,2),
	ItemDescription Text,
	Category VARCHAR(20)
);
CREATE TABLE Transactions(
	TransactionNumber SERIAL PRIMARY KEY,
	DateT DATETIME,
	TotalPrice DECIMAL(7,2)
);
Create TABLE HAS(
	UserNameHas VARCHAR(20),
	TransactionNumberHAS SERIAL,
	FOREIGN KEY (UserNameHas) REFERENCES UserAccounts(UserName),
	FOREIGN KEY (TransactionNumberHas) REFERENCES Transactions(TransactionNumber)
);
CREATE TABLE Delivery(
	myOption CHAR(1) PRIMARY KEY,
	Cost DECIMAL(4,2),
	DeliverDesc VARCHAR(20)
	

);
CREATE TABLE Choice(
	OptionChoice CHAR(1),
	TransactionNumberChoice SERIAL,
	FOREIGN KEY (OptionChoice) REFERENCES Delivery(myOption),
	FOREIGN KEY (TransactionNumberChoice) REFERENCES Transactions(TransactionNumber)
);
CREATE TABLE Buying(
	TransactionNumberBuying SERIAL,
	IsbnBuying VARCHAR(20),
	FOREIGN KEY (TransactionNumberBuying) REFERENCES Transactions(TransactionNumber),
	FOREIGN KEY (IsbnBuying) REFERENCES Goods(ISBN)
);
CREATE TABLE PayPal(
	Balance DECIMAL(10,2),
	CardTypePP VARCHAR(20),
	CardNumPP VARCHAR (20),
	PRIMARY KEY(Balance, CardTypePP, CardNumPP)
);
CREATE TABLE Requests(
	BalanceRequests DECIMAL(10,2),
	CardTypeRequests VARCHAR(20),
	CardNumRequests VARCHAR(20),
	UserNameRequests VARCHAR(20),
	FOREIGN KEY (UserNameRequests) REFERENCES UserAccounts(UserName),
	FOREIGN KEY (BalanceRequests, CardTypeRequests, CardNumRequests) REFERENCES PayPal(Balance, CardTypePP, CardNumPP)
	
);



INSERT INTO UserAccounts (UserName, Password, CardType, CardNum)
VALUES
     ('jamesN','pass11','visaN','11111'),
     ('cartern','pass22','visaN','22222'),
    ('euysungn','pass33','American ExpressN','33333'),
    ('nicholasn','pass44','gold cardN','44444'),
    ('Zhuoningn','pass55','visaN','55555')

;




CREATE TABLE Requests(
	UserNameR VARCHAR(20),
	FOREIGN KEY (UserNameR) REFERENCES UserAccounts(UserName)
        on delete cascade
	
	
);
