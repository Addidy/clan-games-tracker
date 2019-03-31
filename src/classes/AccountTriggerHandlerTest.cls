@istest
public class AccountTriggerHandlerTest {
    @isTest static void test(){
        //setup
        //make existing account on org
        Account acc1 = new Account(name='First Account');
        insert acc1;
        
        List<Account> accounts = new List<Account>();
        acc1.name = 'First Account modified';
        accounts.add(acc1);
        accounts.add(new Account(name='Second Account'));
        //test
        System.debug('account trigger test start');
        upsert accounts;
        
    }
}