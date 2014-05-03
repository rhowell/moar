Mock Acitve Record 
===

Mock Active Record (MoAR) allows you to stub out active record models when testing code.  This allows you to test classes that use ActiveRecord without needing to load all of rails.  This removes much of the startup time associated with running tests. For the average test file on my 2012 Macbook Pro the time to run a single test file goes from 2.7 seconds to around ~300ms.

Usage
===
Add the gem to your Gem file:

 `gem 'moar'`
 
Call `moar:migrate` or `moar:rollback` instead of the db equivilants.  This is the only way ARM can determine the attributes you need.

