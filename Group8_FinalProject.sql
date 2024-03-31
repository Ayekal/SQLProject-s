-- Database creation and activation

-- Disable foreign key checks, unique checks, and set SQL mode
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- Create schema cc14 if not exists
CREATE SCHEMA IF NOT EXISTS cc14 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE cc14;

-- Table: room_type
CREATE TABLE IF NOT EXISTS cc14.`room_type` (
  room_type VARCHAR(50) NOT NULL,
  description TEXT NULL DEFAULT NULL,
  rate VARCHAR(50) NULL DEFAULT NULL,
  PRIMARY KEY (room_type)
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

-- Table: function_type
CREATE TABLE IF NOT EXISTS cc14.`function_type` (
  function_type VARCHAR(50) NOT NULL,
  capacity VARCHAR(50) NULL DEFAULT NULL,
  rate VARCHAR(50) NULL DEFAULT NULL,
  PRIMARY KEY (function_type)
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

-- Table: accommodation
CREATE TABLE IF NOT EXISTS cc14.`accommodation` (
  room_number VARCHAR(50) NOT NULL,
  status VARCHAR(50) NULL DEFAULT NULL,
  floor VARCHAR(50) NULL DEFAULT NULL,
  room_type VARCHAR(50) NULL DEFAULT NULL,
  function_type VARCHAR(50) NULL DEFAULT NULL,
  PRIMARY KEY (room_number),
  INDEX room_type (room_type ASC) VISIBLE,
  INDEX function_type (function_type ASC) VISIBLE,
  CONSTRAINT accommodation_ibfk_1
    FOREIGN KEY (room_type)
    REFERENCES cc14.`room_type` (room_type)
    ON DELETE SET NULL,
  CONSTRAINT accommodation_ibfk_2
    FOREIGN KEY (function_type)
    REFERENCES cc14.`function_type` (function_type)
    ON DELETE SET NULL
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

-- Table: guest
CREATE TABLE IF NOT EXISTS cc14.`guest` (
  guest_id VARCHAR(50) NOT NULL,
  first_name VARCHAR(50) NULL DEFAULT NULL,
  last_name VARCHAR(50) NULL DEFAULT NULL,
  email VARCHAR(50) NULL DEFAULT NULL,
  education VARCHAR(50) NULL DEFAULT NULL,
  occupation VARCHAR(50) NULL DEFAULT NULL,
  PRIMARY KEY (guest_id)
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

-- Table: guest_contact_no
CREATE TABLE IF NOT EXISTS cc14.`guest_contact_no` (
  contact_number VARCHAR(50) NOT NULL,
  guest_id VARCHAR(50) NOT NULL,
  PRIMARY KEY (contact_number, guest_id),
  INDEX guest_contact_no_ibfk_1 (guest_id ASC) VISIBLE,
  CONSTRAINT guest_contact_no_ibfk_1
    FOREIGN KEY (guest_id)
    REFERENCES cc14.`guest` (guest_id)
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

-- Table: payment
CREATE TABLE IF NOT EXISTS cc14.`payment` (
  payment_id VARCHAR(50) NOT NULL,
  payment_method VARCHAR(50) NULL DEFAULT NULL,
  overall_charge VARCHAR(50) NULL DEFAULT NULL,
  bank_account_details VARCHAR(50) NULL DEFAULT NULL,
  PRIMARY KEY (payment_id)
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

-- Table: receptionist
CREATE TABLE IF NOT EXISTS cc14.`receptionist` (
  receptionist_id VARCHAR(50) NOT NULL,
  first_name VARCHAR(50) NULL DEFAULT NULL,
  last_name VARCHAR(50) NULL DEFAULT NULL,
  position VARCHAR(50) NULL DEFAULT NULL,
  shift_hours VARCHAR(50) NULL DEFAULT NULL,
  address VARCHAR(100) NULL DEFAULT NULL,
  PRIMARY KEY (receptionist_id)
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

-- Table: transaction_accommodation
CREATE TABLE IF NOT EXISTS cc14.`transaction_accommodation` (
  transaction_id VARCHAR(50) NOT NULL,
  room_number VARCHAR(50) NULL DEFAULT NULL,
  checkin_date DATE NULL DEFAULT NULL,
  checkout_date DATE NULL DEFAULT NULL,
  PRIMARY KEY (transaction_id),
  INDEX room_number (room_number ASC) VISIBLE,
  CONSTRAINT transaction_accommodation_ibfk_1
    FOREIGN KEY (room_number)
    REFERENCES cc14.`accommodation` (room_number)
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

-- Table: transaction_details
CREATE TABLE IF NOT EXISTS cc14.`transaction_details` (
  transaction_id VARCHAR(50) NOT NULL,
  guest_id VARCHAR(50) NULL DEFAULT NULL,
  receptionist_id VARCHAR(50) NULL DEFAULT NULL,
  transaction_date DATE NULL DEFAULT NULL,
  transaction_time TIME NULL DEFAULT NULL,
  PRIMARY KEY (transaction_id),
  INDEX guest_id (guest_id ASC) VISIBLE,
  INDEX receptionist_id (receptionist_id ASC) VISIBLE,
  CONSTRAINT transaction_details_ibfk_1
    FOREIGN KEY (guest_id)
    REFERENCES cc14.`guest` (guest_id),
  CONSTRAINT transaction_details_ibfk_2
    FOREIGN KEY (receptionist_id)
    REFERENCES cc14.`receptionist` (receptionist_id)
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

-- Table: transaction_payment
CREATE TABLE IF NOT EXISTS cc14.`transaction_payment` (
  transaction_id VARCHAR(50) NOT NULL,
  guest_id VARCHAR(50) NULL DEFAULT NULL,
  receptionist_id VARCHAR(50) NULL DEFAULT NULL,
  payment_id VARCHAR(50) NULL DEFAULT NULL,
  downpayment VARCHAR(50) NULL DEFAULT NULL,
  reservation_mode VARCHAR(50) NULL DEFAULT NULL,
  full_payment VARCHAR(50) NULL DEFAULT NULL,
  PRIMARY KEY (transaction_id),
  INDEX guest_id (guest_id ASC) VISIBLE,
  INDEX receptionist_id (receptionist_id ASC) VISIBLE,
  INDEX payment_id (payment_id ASC) VISIBLE,
  CONSTRAINT transaction_payment_ibfk_1
    FOREIGN KEY (guest_id)
    REFERENCES cc14.`guest` (guest_id),
  CONSTRAINT transaction_payment_ibfk_2
    FOREIGN KEY (receptionist_id)
    REFERENCES cc14.`receptionist` (receptionist_id),
  CONSTRAINT transaction_payment_ibfk_3
    FOREIGN KEY (payment_id)
    REFERENCES cc14.`payment` (payment_id)
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

-- Reset SQL mode, foreign key checks, and unique checks to their original values
SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;


-- Data insertion statements

-- Insertion statements for 'receptionist' table
INSERT INTO receptionist (receptionist_id, first_name, last_name, position, shift_hours, address)
VALUES
    ('REC001', 'Mary', 'Taylor', 'Front Desk Staff', '8am - 4pm', '123 Main St.'),
    ('REC002', 'John', 'Lee', 'Front Desk Staff', '12pm - 8pm', '456 Park Rd.'),
    ('REC003', 'Sarah', 'Chen', 'Front Desk Staff', '4pm - 12am', '789 Center St.'),
    ('REC004', 'Mike', 'Davis', 'Front Desk Manager', '8am - 4pm', '987 Oak Rd.'),
    ('REC005', 'Jessica', 'Lopez', 'Front Desk Staff', '12pm - 8pm', '321 Elm St.'),
    ('REC006', 'David', 'Wang', 'Front Desk Manager', '4pm - 12am', '654 Pine Blvd.'),
    ('REC007', 'Nancy', 'Allen', 'Front Desk Staff', '8am - 4pm', '741 Birch Ln.'),
    ('REC008', 'Sam', 'Martinez', 'Front Desk Staff', '12pm - 8pm', '159 Maple Dr.');

-- Insertion statements for 'payment' table
INSERT INTO payment (payment_id, payment_method, overall_charge, bank_account_details)
VALUES
    ('PAY001', 'Credit Card', '$2500', 'BPI'),
    ('PAY002', 'Debit Card', '$2000', 'BDO'),
    ('PAY003', 'Cash', '$2800', NULL),
    ('PAY004', 'Cash', '$2400', NULL),
    ('PAY005', 'Credit Card', '$2000', 'BDO'),
    ('PAY006', 'Debit Card', '$2600', 'LandBank'),
    ('PAY007', 'Credit Card', '$3000', 'BDO'),
    ('PAY008', 'Cash', '$2200', NULL);

-- Insertion statements for 'room_type' table
INSERT INTO room_type (room_type, description, rate)
VALUES
    ('Deluxe Room', '1 King bed. The most expensive and luxurious room type, with the most amenities and features. Maximum Capacity of 3.', '$165/night'),
    ('Standard Room', '1 Full bed. The standard room type, with the standard set of amenities and functions for daily activities. Maximum Capacity of 2.', '$85/night');

-- Insertion statements for 'function_type' table
INSERT INTO function_type (function_type, capacity, rate)
VALUES
    ('Meeting Room', '12-20 pax', '$50/day'),
    ('Banquet Hall', '200-400 pax', '$200/day'),
    ('Conference Room', '25 - 50 pax', '$80/day');

-- Insertion statements for 'guest' table
INSERT INTO guest (guest_id, first_name, last_name, email, education, occupation)
VALUES
    ('GST001', 'John', 'Doe', 'johndoe@email.com', 'NULL', 'Business Analyst'),
    ('GST002', 'Jane', 'Smith', 'janesmith@email.com', 'High School Diploma', 'NULL'),
    ('GST003', 'Mark', 'Johnson', 'markjohnson@email.com', 'Master of Science in Engineering', 'NULL'),
    ('GST004', 'Bob', 'Wilson', 'bwilson@email.com', 'Bachelor of Education', 'NULL'),
    ('GST005', 'Sue', 'Chen', 'schen@email.com', 'NULL', 'Event Planner'),
    ('GST006', 'Tom', 'Garcia', 'tgarcia@email.com', 'NULL', 'Accountant'),
    ('GST007', 'Sarah', 'Lee', 'slee@email.com', 'NULL', 'Data Analyst'),
    ('GST008', 'James', 'Smith', 'jsmith@email.com', 'Bachelor of Science in Nursing', 'Null');

-- Insertion statements for 'guest_contact_no' table
INSERT INTO guest_contact_no (guest_id, contact_number)
VALUES
    ('GST001', '0912-345-6789'),
    ('GST002', '0923-456-7891'),
    ('GST003', '0934-567-8912'),
    ('GST004', '0945-678-9123'),
    ('GST005', '0956-789-1234'),
    ('GST006', '0967-890-2345'),
    ('GST007', '0978-901-3456'),
    ('GST008', '0989-012-4567');

-- Insertion statements for 'transaction_details' table
INSERT INTO transaction_details (transaction_id, guest_id, receptionist_id, transaction_date, transaction_time)
VALUES
    ('TXN001', 'GST001', 'REC001', '2022-10-15', '10:30'),
    ('TXN002', 'GST002', 'REC002', '2022-11-24', '14:15'),
    ('TXN003', 'GST003', 'REC003', '2022-09-30', '14:45'),
    ('TXN004', 'GST004', 'REC004', '2022-12-01', '09:00'),
    ('TXN005', 'GST005', 'REC005', '2022-10-12', '13:30'),
    ('TXN006', 'GST006', 'REC006', '2022-11-15', '16:45'),
    ('TXN007', 'GST007', 'REC007', '2022-12-20', '15:15'),
    ('TXN008', 'GST008', 'REC008', '2022-09-25', '13:00');

-- Insertion statements for 'transaction_payment' table
INSERT INTO transaction_payment (transaction_id, guest_id, receptionist_id, payment_id, downpayment, reservation_mode, full_payment)
VALUES
    ('TXN001', 'GST001', 'REC001', 'PAY001', NULL, NULL, '$250'),
    ('TXN002', 'GST002', 'REC002', 'PAY002', NULL, NULL, '$990'),
    ('TXN003', 'GST003', 'REC003', 'PAY003', '$40', 'Phone Reservation', NULL),
    ('TXN004', 'GST004', 'REC004', 'PAY004', '$25', 'Online Reservation', NULL),
    ('TXN005', 'GST005', 'REC005', 'PAY005', '$110', 'Walk-in', NULL),
    ('TXN006', 'GST006', 'REC006', 'PAY006', NULL, NULL, '$495'),
    ('TXN007', 'GST007', 'REC007', 'PAY007', '$40', 'Online Reservation', NULL),
    ('TXN008', 'GST008', 'REC008', 'PAY008', '$50', 'Walk-in', NULL);

-- Insertion statements for 'accommodation' table
INSERT INTO accommodation (room_number, status, floor, room_type, function_type)
VALUES
    ('RM101', 'Vacant', '1st floor', NULL, 'Meeting Room'),
    ('RM206', 'Vacant', '2nd floor', 'Deluxe Room', NULL),
    ('RM303', 'Booked', '3rd floor', 'Standard Room', NULL),
    ('RM404', 'Booked', '4th floor', NULL, 'Meeting Room'),
    ('RM555', 'Booked', '5th floor', NULL, 'Banquet Hall'),
    ('RM906', 'Vacant', '9th floor', 'Deluxe Room', NULL),
    ('RM407', 'Booked', '4th floor', 'Standard Room', NULL),
    ('RM508', 'Booked', '5th floor', NULL, 'Conference Room');

-- Insertion statements for 'transaction_accommodation' table
INSERT INTO transaction_accommodation (transaction_id, room_number, checkin_date, checkout_date)
VALUES
    ('TXN001', 'RM101', '2022-11-01', '2022-11-05'),
    ('TXN002', 'RM206', '2022-12-01', '2022-12-07'),
    ('TXN003', 'RM303', '2022-10-12', '2022-11-12'),
    ('TXN004', 'RM404', '2022-12-15', '2022-12-20'),
    ('TXN005', 'RM555', '2022-11-20', '2022-11-27'),
    ('TXN006', 'RM906', '2022-12-12', '2022-12-30'),
    ('TXN007', 'RM407', '2023-01-05', '2023-01-30'),
    ('TXN008', 'RM508', '2022-10-30', '2022-11-05');