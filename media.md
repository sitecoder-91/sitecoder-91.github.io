---
layout: page
title: Media
subtitle: "Moments & Memories"
full-width: true
share-description: "Explore the media gallery of Nara Domingos. Browse intimate photos, videos, and captured memories of a premium UK companion & elite GFE provider."
---

<!-- Filter Buttons -->
<div class="media-filter-container">
  <button class="filter-btn active" data-filter="all">All</button>
  <button class="filter-btn" data-filter="image">Photos</button>
  <button class="filter-btn" data-filter="video">Videos</button>
</div>

<!-- Gallery Grid -->
<div class="media-grid" id="media-grid">
  {% assign files = site.static_files | where_exp: "item", "item.path contains 'assets/media/'" %}
  {% for file in files %}
    {% assign ext = file.extname | downcase %}
    {% if ext == '.jpg' or ext == '.jpeg' or ext == '.png' or ext == '.gif' or ext == '.webp' %}
      <div class="media-item" data-src="{{ file.path | relative_url }}" data-type="image" aria-label="View Image">
        <img src="{{ file.path | relative_url }}" alt="Nara Domingos Media Image" loading="lazy" />
      </div>
    {% elsif ext == '.mp4' or ext == '.mov' or ext == '.webm' %}
      <div class="media-item" data-src="{{ file.path | relative_url }}" data-type="video" aria-label="Play Video">
        <div class="video-thumbnail-wrapper">
          <video src="{{ file.path | relative_url }}#t=0.5" preload="metadata" muted playsinline></video>
          <div class="play-overlay">
            <i class="fas fa-play"></i>
          </div>
        </div>
      </div>
    {% endif %}
  {% endfor %}
</div>

<!-- Lightbox Modal -->
<div class="lightbox-modal" id="lightbox-modal" role="dialog" aria-modal="true" aria-label="Media Viewer">
  <div class="lightbox-content-container">
    <button class="lightbox-close" id="lightbox-close" aria-label="Close viewer">&times;</button>
    <button class="lightbox-prev" id="lightbox-prev" aria-label="Previous media"><i class="fas fa-chevron-left"></i></button>
    
    <img id="lightbox-img" class="lightbox-media" src="" alt="Full-screen view" />
    <video id="lightbox-video" class="lightbox-media" controls src="" playsinline></video>
    
    <button class="lightbox-next" id="lightbox-next" aria-label="Next media"><i class="fas fa-chevron-right"></i></button>
  </div>
</div>

<script src="{{ '/assets/js/media-gallery.js' | relative_url }}"></script>
