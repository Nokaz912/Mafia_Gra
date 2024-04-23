package pl.mafia.backend.models.dto;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import pl.mafia.backend.models.db.Account;

import java.util.Collection;
import java.util.HashSet;
import java.util.Locale;
import java.util.Set;

public class AccountDetails implements UserDetails {
    private final String username;
    private final String password;
    private final String email;

    public AccountDetails() {
        username = "";
        password = "";
        email = "";
    }
    public AccountDetails(Account account) {
        username = account.getUsername();
        password = account.getPassword();
        email = account.getEmail();
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        Set<GrantedAuthority> grantedAuthorities = new HashSet<>();
        grantedAuthorities.add(new SimpleGrantedAuthority("USER"));
        return grantedAuthorities;
    }

    @Override
    public String getPassword() {
        return password;
    }

    @Override
    public String getUsername() {
        return username;
    }

    public String getEmail() {
        return email;
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return true;
    }
}
