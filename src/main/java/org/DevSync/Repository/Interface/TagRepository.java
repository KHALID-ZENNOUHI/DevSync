package org.DevSync.Repository.Interface;

import org.DevSync.Domain.Tag;

import java.util.List;
import java.util.Optional;

public interface TagRepository {
    Tag create(Tag tag);
    Optional<Tag> findById(Long id);
    Tag update(Tag tag);
    void delete(Long id);
    Optional<Tag> findByName(String name);
    List<Tag> findAll();
}
