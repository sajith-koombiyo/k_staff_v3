import 'package:flutter_application_2/uI/main/drawer/genaral/add_employe/add_employee.dart';

class DrawerClz {
//   1	SUP	Super Admin
// 2	MGR	Area Manager
// 3	BS	Branch Supervisor
// 4	ISM	Issue Management
// 5	RM	Regional Manager
// 6	RTN	Return Department
// 8	HOM	Head Office Manager
// 9	OPE	Operation
// 11	CCO	Customer Care
// 12	NOP	Night Operations
// 13	ACC	Accounts
// 14	PKP	Pickup
// 15	HCC	Key Accounts
// 16	ADM	ADMIN
// 17	RDR	RIDER
// 18	NIC	Night In-charge
// 19	SLS	Sales
// 20	ACS	Account Assistant
// 21	ACE	Account Executive
// 22	CC	Call Center
// 23	ADT	Audit
// 24		Multi Duty Clark
// 25	QC Team
// 26	HR Department
// 27	shutter Driver

  pickedList(int accessId) {
    List data = [1, 17];

    if (data.contains(accessId) == true) {
      return true;
    } else {
      return false;
    }
  }

  oderAllDetail(int accessId) {
    List data = [17];

    if (data.contains(accessId) == true) {
      return true;
    } else {
      return false;
    }
  }

  branchOperation(int accessId) {
    List data = [1, 2, 3];

    if (data.contains(accessId) == true) {
      return true;
    } else {
      return false;
    }
  }

  pickup(int accessId) {
    List data = [1, 17];

    if (data.contains(accessId) == true) {
      return true;
    } else {
      return false;
    }
  }

  pendingPickup(int accessId) {
    List data = [1, 17, 3, 2];

    if (data.contains(accessId) == true) {
      return true;
    } else {
      return false;
    }
  }

  AssigngPickup(int accessId) {
    List data = [1, 2];

    if (data.contains(accessId) == true) {
      return true;
    } else {
      return false;
    }
  }

  myDelivery(int accessId) {
    List data = [1, 17];

    if (data.contains(accessId) == true) {
      return true;
    } else {
      return false;
    }
  }

  inOut(int accessId) {
    List data = [1, 17, 27];

    if (data.contains(accessId) == true) {
      return true;
    } else {
      return false;
    }
  }

  myOrders(int accessId) {
    List data = [1, 17];

    if (data.contains(accessId) == true) {
      return true;
    } else {
      return false;
    }
  }

  reschedule(int accessId) {
    List data = [1, 17];

    if (data.contains(accessId) == true) {
      return true;
    } else {
      return false;
    }
  }

  BranchOperation(int accessId) {
    List data = [1, 17, 3, 2];

    if (data.contains(accessId) == true) {
      return true;
    } else {
      return false;
    }
  }

  ddApprove(int accessId) {
    List data = [1, 2];

    if (data.contains(accessId) == true) {
      return true;
    } else {
      return false;
    }
  }

  codZero(int accessId) {
    List data = [1, 3];

    if (data.contains(accessId) == true) {
      return true;
    } else {
      return false;
    }
  }

  addEmployee(int accessId) {
    List data = [1, 2];

    if (data.contains(accessId) == true) {
      return true;
    } else {
      return false;
    }
  }

  manageUser(int accessId) {
    List data = [1, 2, 3];

    if (data.contains(accessId) == true) {
      return true;
    } else {
      return false;
    }
  }

  employee(int accessId) {
    List data = [1];

    if (data.contains(accessId) == true) {
      return true;
    } else {
      return false;
    }
  }
  //0769306568

  contact(int accessId) {
    List data = [1, 2, 3];

    if (data.contains(accessId) == true) {
      return true;
    } else {
      return false;
    }
  }

  attendance(int accessId) {
    List data = [1, 17];

    if (data.contains(accessId) == true) {
      return true;
    } else {
      return false;
    }
  }

  shuttle(int accessId) {
    List data = [1, 27];

    if (data.contains(accessId) == true) {
      return true;
    } else {
      return false;
    }
  }

  branchDeposit(int accessId) {
    List data = [1, 2, 3, 13, 20, 21, 5, 24];

    if (data.contains(accessId) == true) {
      return true;
    } else {
      return false;
    }
  }

  branchDepositaddData(int accessId) {
    List data = [
      2,
      3,
    ];

    if (data.contains(accessId) == true) {
      return true;
    } else {
      return false;
    }
  }

  branchVisit(int accessId) {
    List data = [1, 2, 3, 9];

    if (data.contains(accessId) == true) {
      return true;
    } else {
      return false;
    }
  }
}
