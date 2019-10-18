USE Normalization1;
DROP TABLE IF EXISTS email;

CREATE TABLE email (
  email_ID int(11) NOT NULL auto_increment,
  email VARCHAR(50) NOT NULL,
  PRIMARY KEY  (email_ID)
) AS
	SELECT DISTINCT email
	FROM my_contacts
	WHERE email IS NOT NULL;


ALTER TABLE my_contacts
	ADD COLUMN email_ID INT(11);

UPDATE my_contacts
	INNER JOIN email
	ON email.email = my_contacts.email
	SET my_contacts.email_ID = email.email_ID
	WHERE email.email IS NOT NULL;

ALTER TABLE my_contacts
	DROP COLUMN email;