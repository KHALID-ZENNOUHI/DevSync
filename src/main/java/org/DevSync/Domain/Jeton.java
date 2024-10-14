package org.DevSync.Domain;

import jakarta.persistence.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "jetons")
public class Jeton {

        @Id
        @GeneratedValue(strategy = GenerationType.IDENTITY)
        private int id;

        @ManyToOne
        @JoinColumn(name = "user_id", nullable = false)
        private User user;

        @Column(name = "change_jeton", nullable = false)
        private int changeJeton;

        @Column(name = "delete_jeton", nullable = false)
        private int deleteJeton;

        @Column(name = "reset_change_jetons", nullable = false , columnDefinition = "int default 0")
        private int resetChangeJetons;

        @Column(name = "reset_delete_jetons", nullable = false , columnDefinition = "int default 0")
        private int resetDeleteJetons;

        @Column(name = "last_reset_date")
        private LocalDateTime lastResetDate;

        public Jeton() {}

        public Jeton(User user, int changeJeton, int deleteJeton, int resetChangeJetons, int resetDeleteJetons, LocalDateTime lastResetDate) {
            this.user = user;
            this.changeJeton = changeJeton;
            this.deleteJeton = deleteJeton;
            this.resetChangeJetons = resetChangeJetons;
            this.resetDeleteJetons = resetDeleteJetons;
            this.lastResetDate = lastResetDate;
        }

        public int getId() {
            return id;
        }

        public void setId(int id) {
            this.id = id;
        }

        public User getUser() {
            return user;
        }

        public void setUser(User user) {
            this.user = user;
        }

        public int getChangeJeton() {
            return changeJeton;
        }

        public void setChangeJeton(int changeJeton) {
            this.changeJeton = changeJeton;
        }

        public int getDeleteJeton() {
            return deleteJeton;
        }

        public void setDeleteJeton(int deleteJeton) {
            this.deleteJeton = deleteJeton;
        }

        public int getResetChangeJetons() {
            return resetChangeJetons;
        }

        public void setResetChangeJetons(int resetChangeJetons) {
            this.resetChangeJetons = resetChangeJetons;
        }

        public int getResetDeleteJetons() {
                return resetDeleteJetons;
        }

        public void setResetDeleteJetons(int resetDeleteJetons) {
            this.resetDeleteJetons = resetDeleteJetons;
        }

        public LocalDateTime getLastResetDate() {
            return lastResetDate;
        }

        public void setLastResetDate(LocalDateTime lastResetDate) {
            this.lastResetDate = lastResetDate;
        }

}
