package org.DevSync.service.Interface;

import org.DevSync.domain.Tag;

import java.util.List;
import java.util.Optional;

public interface TagService {
    Tag create(Tag tag);
    Optional<Tag> findById(Long id);
    Optional<Tag> findByName(String name);
    Tag update(Tag tag);
    void delete(Long id);
    List<Tag> findAll();
}
