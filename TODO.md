Question:
1. twice submit: disable submit not working. ==> payments.js
2. invite_friend_spec.rb testing not stable,
   can't use 'localhost:52662', must use '127.0.0.1:52662' ==> environments/test.rb:17
   must sleep(2) after friend sign up. ==> invite_friend_spec.rb:41

3. users_controller_spec:57, how to test auto sign in?

4. I run into a problem, and can't find solution.
   This bug is not always happen, but the high frequency of occurrence, any one has same situation?

   The bug like follow, when `NoResponseError` happen, then followed by a lot of `Errno::EPIPE:` error
   ```
   Failure/Error: expect(page).to have_content 'Please fix the errors below.'
        Capybara::Webkit::NoResponseError:
          No response received from the server.
        # ./spec/features/user_registers_spec.rb:37:in `block (2 levels) in <top (required)>'

     2) User registers with valid personal but declined credit card
        Failure/Error: visit '/register'
        Errno::EPIPE:
          Broken pipe
        # ./spec/features/user_registers_spec.rb:5:in `block (2 levels) in <top (required)>'

     3) User registers with valid personal and valid credit card
        Failure/Error: visit '/register'
        Errno::EPIPE:
          Broken pipe
        # ./spec/features/user_registers_spec.rb:5:in `block (2 levels) in <top (required)>'
   ```