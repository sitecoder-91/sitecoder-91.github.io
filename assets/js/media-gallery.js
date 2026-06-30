document.addEventListener('DOMContentLoaded', () => {
  const mediaItems = Array.from(document.querySelectorAll('.media-item'));
  const modal = document.getElementById('lightbox-modal');
  const modalImg = document.getElementById('lightbox-img');
  const modalVideo = document.getElementById('lightbox-video');
  const closeBtn = document.getElementById('lightbox-close');
  const prevBtn = document.getElementById('lightbox-prev');
  const nextBtn = document.getElementById('lightbox-next');
  
  if (!modal || mediaItems.length === 0) return;
  
  let currentIndex = 0;
  
  // Map media items to structured objects and set up click handlers
  const playlist = mediaItems.map((item, index) => {
    const src = item.getAttribute('data-src');
    const type = item.getAttribute('data-type');
    
    item.addEventListener('click', () => {
      window.dataLayer = window.dataLayer || [];
      window.dataLayer.push({
        event: 'gallery_view',
        media_src: src,
        media_type: type
      });
      openLightbox(index);
    });
    
    return { src, type };
  });
  
  function openLightbox(index) {
    currentIndex = index;
    modal.classList.add('show');
    document.body.style.overflow = 'hidden'; // Lock background scroll
    loadMedia(currentIndex);
  }
  
  function closeLightbox() {
    modal.classList.remove('show');
    document.body.style.overflow = ''; // Restore scroll
    
    // Stop video playback and clear sources to release memory/stop audio
    modalVideo.pause();
    modalVideo.src = '';
    modalImg.src = '';
    
    modalImg.classList.remove('active');
    modalVideo.classList.remove('active');
  }
  
  function loadMedia(index) {
    const item = playlist[index];
    if (!item) return;
    
    // Reset active states and hide previous elements
    modalImg.classList.remove('active');
    modalVideo.classList.remove('active');
    modalVideo.pause();
    modalVideo.src = '';
    modalImg.src = '';
    
    if (item.type === 'image') {
      modalImg.src = item.src;
      modalImg.classList.add('active');
    } else if (item.type === 'video') {
      modalVideo.src = item.src;
      modalVideo.classList.add('active');
      modalVideo.load();
      // Safely try to autoplay the video in the lightbox
      modalVideo.play().catch(err => {
        console.log("Autoplay was prevented or video could not play:", err);
      });
    }
  }
  
  function showNext() {
    currentIndex = (currentIndex + 1) % playlist.length;
    loadMedia(currentIndex);
  }
  
  function showPrev() {
    currentIndex = (currentIndex - 1 + playlist.length) % playlist.length;
    loadMedia(currentIndex);
  }
  
  // Event listeners
  closeBtn.addEventListener('click', closeLightbox);
  nextBtn.addEventListener('click', (e) => {
    e.stopPropagation();
    showNext();
  });
  prevBtn.addEventListener('click', (e) => {
    e.stopPropagation();
    showPrev();
  });
  
  // Close when clicking backdrop (modal background)
  modal.addEventListener('click', (e) => {
    if (e.target === modal || e.target.classList.contains('lightbox-content-container')) {
      closeLightbox();
    }
  });
  
  // Keyboard listeners
  document.addEventListener('keydown', (e) => {
    if (!modal.classList.contains('show')) return;
    
    if (e.key === 'Escape') {
      closeLightbox();
    } else if (e.key === 'ArrowRight') {
      showNext();
    } else if (e.key === 'ArrowLeft') {
      showPrev();
    }
  });

  // Touch Swipe navigation support for mobile
  let touchStartX = 0;
  let touchEndX = 0;
  
  modal.addEventListener('touchstart', (e) => {
    touchStartX = e.changedTouches[0].screenX;
  }, { passive: true });
  
  modal.addEventListener('touchend', (e) => {
    touchEndX = e.changedTouches[0].screenX;
    handleSwipe();
  }, { passive: true });
  
  function handleSwipe() {
    const swipeThreshold = 50;
    if (touchEndX < touchStartX - swipeThreshold) {
      showNext(); // Swipe Left -> Show Next
    } else if (touchEndX > touchStartX + swipeThreshold) {
      showPrev(); // Swipe Right -> Show Prev
    }
  }
});
