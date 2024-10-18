package org.DevSync.service.Implementation;

import org.DevSync.domain.Enum.UserType;
import org.DevSync.domain.User;
import org.DevSync.exceptions.*;
import org.DevSync.repository.Implementation.UserRepositoryImpl;
import org.DevSync.util.PasswordHash;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.MethodSource;
import org.mockito.*;

import java.util.stream.Stream;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

class UserServiceImplTest {

    @Mock
    private UserRepositoryImpl userRepository;

    @InjectMocks
    private UserServiceImpl userService;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
    }

    static Stream<User> generateUsers() {
        String password = PasswordHash.hashPassword("password");
        return Stream.of(
                new User("poll", "John", "Doe", "john@gmail.com", password, UserType.USER)
        );
    }

    @Test
    void testCreateNullUser() {
        assertThrows(NullUserException.class, () -> userService.create(null));
    }

    @ParameterizedTest
    @MethodSource("generateUsers")
    void testCreateUser(User user) {
            when(userService.create(user)).thenReturn(user);
            when(userRepository.create(user)).thenReturn(user);
            assertEquals(user, userService.create(user));
            verify(userRepository).create(user);
    }

    @ParameterizedTest
    @MethodSource("generateUsers")
    void testCreateExistingUser(User user) {
        when(userRepository.findByEmail(user.getEmail())).thenReturn(java.util.Optional.of(user));
        assertThrows(ExistUserException.class, () -> userService.create(user));
        verify(userRepository).findByEmail(user.getEmail());
    }

    @ParameterizedTest
    @MethodSource("generateUsers")
    void testCreateEmptyUser() {
        User user = new User();
        assertThrows(EmptyUserException.class, () -> userService.create(user));
    }

    @ParameterizedTest
    @MethodSource("generateUsers")
    void testCreateUserWithId(User user) {
        user.setId(1L);
        assertThrows(PreAssignedIdException.class, () -> userService.create(user));
        verify(userRepository, Mockito.never()).create(user);
    }

    @Test
    void testUpdateNullUser() {
        assertThrows(NullUserException.class, () -> userService.update(null));
    }

    @ParameterizedTest
    @MethodSource("generateUsers")
    void testUpdateUser(User user) {
        when(userRepository.findById(user.getId())).thenReturn(java.util.Optional.of(user));
        when(userRepository.update(user)).thenReturn(user);
        assertEquals(user, userService.update(user));
        verify(userRepository).update(user);
    }

    @ParameterizedTest
    @MethodSource("generateUsers")
    void testUpdateNonExistingUser(User user) {
        when(userRepository.findById(user.getId())).thenReturn(java.util.Optional.empty());
        assertThrows(UserNotFoundException.class, () -> userService.update(user));
        verify(userRepository, Mockito.never()).update(user);
    }

    @ParameterizedTest
    @MethodSource("generateUsers")
    void testUpdateEmptyUser(User user) {
        User emptyUser = new User();
        assertThrows(EmptyUserException.class, () -> userService.update(emptyUser));
    }

    @ParameterizedTest
    @MethodSource("generateUsers")
    void testUpdateUserWithNullId(User user) {
        user.setId(null);
        assertThrows(NullOrInvalidID.class, () -> userService.update(user));
        verify(userRepository, Mockito.never()).update(user);
    }

    @Test
    void testDeleteUserWithNullID() {
        assertThrows(NullOrInvalidID.class, () -> userService.delete(null));
    }

    @Test
    void testDeleteUserWithInvalidID() {
        Long id = -1L;
        assertThrows(NullOrInvalidID.class, () -> userService.delete(id));
    }

    @Test
    void testDeleteNonExistingUser() {
        Long id = 1L;
        when(userRepository.findById(id)).thenReturn(java.util.Optional.empty());
        assertThrows(UserNotFoundException.class, () -> userService.delete(id));
        verify(userRepository, Mockito.never()).delete(id);
    }

    @ParameterizedTest
    @MethodSource("generateUsers")
    void testDeleteUser(User user) {
        user.setId(1L);
        when(userRepository.findById(user.getId())).thenReturn(java.util.Optional.of(user));
        userService.delete(user.getId());
        verify(userRepository).delete(user.getId());
    }









}