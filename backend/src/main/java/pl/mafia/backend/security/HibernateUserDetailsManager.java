package pl.mafia.backend.security;

import org.mindrot.jbcrypt.BCrypt;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.provisioning.UserDetailsManager;
import org.springframework.transaction.annotation.Transactional;
import pl.mafia.backend.models.db.Account;
import pl.mafia.backend.models.dto.AccountDetails;
import pl.mafia.backend.repositories.AccountRepository;

import java.util.HashSet;
import java.util.Optional;
import java.util.Set;

public class HibernateUserDetailsManager implements UserDetailsManager {
    @Autowired
    private AccountRepository accountRepository;
    @Autowired
    private PasswordEncoder passwordEncoder;

    @Override
    @Transactional(readOnly = true)
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        Optional<Account> account = accountRepository.findByUsername(username);
        if(account.isEmpty())
            throw new UsernameNotFoundException("Account not found");

        return new AccountDetails(account.get());
    }

    @Override
    @Transactional
    public void createUser(UserDetails user) {
        AccountDetails accountDetails = (AccountDetails) user;

        Optional<Account> accountByUsername = accountRepository.findByUsername(accountDetails.getUsername());
        Optional<Account> accountByEmail = accountRepository.findByEmail(accountDetails.getEmail());

        if(accountByUsername.isPresent() || accountByEmail.isPresent()) {
            throw new IllegalArgumentException("Account already exists.");
        }

        String encodedPassword = passwordEncoder.encode(accountDetails.getPassword());
        Account account = new Account();
        account.setEmail(accountDetails.getEmail());
        account.setUsername(accountDetails.getUsername());
        account.setPassword(encodedPassword);
        accountRepository.save(account);
    }

    @Override
    public void updateUser(UserDetails user) {

    }

    @Override
    public void deleteUser(String username) {

    }

    @Override
    public void changePassword(String oldPassword, String newPassword) {

    }

    @Override
    public boolean userExists(String username) {
        return false;
    }
}
