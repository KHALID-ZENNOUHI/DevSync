package org.DevSync.Service.Implementation;

import org.DevSync.Domain.Tag;
import org.DevSync.Repository.Implementation.TagRepositoryImpl;
import org.DevSync.Repository.Interface.TagRepository;
import org.DevSync.Service.Interface.TagService;

import java.util.List;
import java.util.Optional;

public class TagServiceImpl implements TagService {
    private final TagRepository tagRepository;

    public TagServiceImpl() {
        this.tagRepository = new TagRepositoryImpl();
    }

    @Override
    public Tag create(Tag tag) {
        validateTag(tag);
        checkIfTagExists(tag.getName());
        return this.tagRepository.create(tag);
    }

    @Override
    public Optional<Tag> findById(Long id) {
        return this.tagRepository.findById(id);
    }

    @Override
    public Optional<Tag> findByName(String name) {
        return this.tagRepository.findByName(name);
    }

    @Override
    public Tag update(Tag tag) {
        validateTag(tag);
        return this.tagRepository.update(tag);
    }

    @Override
    public void delete(Long id) {
        this.tagRepository.delete(id);
    }

    @Override
    public List<Tag> findAll() {
        return this.tagRepository.findAll();
    }

    public void validateTag(Tag tag) {
        if (tag.getName() == null || tag.getName().isEmpty()) {
            throw new IllegalArgumentException("Tag name cannot be empty");
        }
    }

    public void checkIfTagExists(String name) {
        findByName(name).ifPresent(tag -> {
            throw new IllegalArgumentException("Tag with name " + name + " already exists");
        });
    }

}
