import 'package:omnus/Database/DataHelper.dart';
import 'package:omnus/Database/DataModels.dart';
import 'package:omnus/Models/Account.dart';

class DataFunctions {
  
  Future<List<StoredAccount>> getAllAccounts() async {
    DataHelper helper = DataHelper.instance;
    return await helper.queryAllAccounts();
  }

  Future<List<StoredAccount>> getAccountsByType(String type) async {
    DataHelper helper = DataHelper.instance;
    return await helper.queryAccountByType(type);
  }

  saveAccount(Account a) async {
    StoredAccount account = StoredAccount.fromAccount(a);
    DataHelper helper = DataHelper.instance;
    await helper.addAccount(account);
  }

  deleteAccount(Account a) async {
    DataHelper helper = DataHelper.instance;
    await helper.deleteAccount(a.number);
  }

  updateTable(String columnName) async {
    DataHelper helper = DataHelper.instance;
    await helper.updateDatabase(columnName);
  }
}