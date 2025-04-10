<script setup>
import { ref } from "vue";
import { Head, Link } from "@inertiajs/vue3";
import AppLayout from "@/Layouts/AppLayout.vue";
import Button from "@/Components/Button.vue";
import Badge from "@/Components/Badge.vue";

const props = defineProps({
    series: Object,
    filters: Object,
});

const selectedSeries = ref([]);

const toggleSeries = (seriesId) => {
    const index = selectedSeries.value.indexOf(seriesId);
    if (index === -1) {
        selectedSeries.value.push(seriesId);
    } else {
        selectedSeries.value.splice(index, 1);
    }
};

const deleteSelected = () => {
    if (confirm(`Are you sure you want to delete ${selectedSeries.value.length} series?`)) {
        router.delete(route("series.destroy", { ids: selectedSeries.value }), {
            onSuccess: () => {
                selectedSeries.value = [];
            },
        });
    }
};

const formatDate = (date) => {
    return date ? new Date(date).toLocaleDateString() : '-';
};
</script>

<template>
    <AppLayout>
        <Head title="TV Series" />

        <template #header>
            <div class="flex items-center justify-between">
                <h2 class="font-semibold text-xl text-gray-800 leading-tight">
                    TV Series
                </h2>

                <div class="flex items-center space-x-4">
                    <Button
                        v-if="selectedSeries.length > 0"
                        variant="danger"
                        size="sm"
                        @click="deleteSelected"
                    >
                        Delete Selected ({{ selectedSeries.length }})
                    </Button>

                    <Button
                        href="/series/create"
                        size="sm"
                    >
                        Add Series
                    </Button>
                </div>
            </div>
        </template>

        <div class="py-12">
            <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
                <div class="bg-white overflow-hidden shadow-sm sm:rounded-lg">
                    <div class="p-6 bg-white border-b border-gray-200">
                        <!-- Grid View -->
                        <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
                            <div
                                v-for="item in series.data"
                                :key="item.id"
                                class="relative group"
                            >
                                <div class="aspect-w-2 aspect-h-3 rounded-lg overflow-hidden">
                                    <img
                                        :src="item.poster || '/default-series.png'"
                                        :alt="item.name"
                                        class="object-cover"
                                    >
                                    <div class="absolute inset-0 bg-black bg-opacity-50 opacity-0 group-hover:opacity-100 transition-opacity">
                                        <div class="absolute inset-0 flex flex-col justify-between p-4">
                                            <div class="flex justify-between">
                                                <input
                                                    type="checkbox"
                                                    :checked="selectedSeries.includes(item.id)"
                                                    @change="toggleSeries(item.id)"
                                                    class="focus:ring-primary-500 h-4 w-4 text-primary-600 border-gray-300 rounded"
                                                >
                                                <Badge :variant="item.is_active ? 'success' : 'danger'">
                                                    {{ item.is_active ? "Active" : "Inactive" }}
                                                </Badge>
                                            </div>
                                            <div>
                                                <h3 class="text-white font-medium">{{ item.name }}</h3>
                                                <p class="text-gray-300 text-sm">{{ item.seasons?.length || 0 }} Seasons</p>
                                                <p class="text-gray-300 text-sm">{{ formatDate(item.release_date) }}</p>
                                                <div class="mt-2">
                                                    <Badge>{{ item.category?.name || "Uncategorized" }}</Badge>
                                                </div>
                                                <div class="mt-4 flex space-x-2">
                                                    <Link :href="`/series/${item.id}`" class="text-white hover:text-primary-300">
                                                        View
                                                    </Link>
                                                    <Link :href="`/series/${item.id}/edit`" class="text-white hover:text-primary-300">
                                                        Edit
                                                    </Link>
                                                    <button
                                                        @click.prevent="() => router.delete(`/series/${item.id}`)"
                                                        class="text-white hover:text-red-300"
                                                    >
                                                        Delete
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Pagination -->
                        <div class="mt-6">
                            <div class="flex items-center justify-between">
                                <div class="flex-1 flex justify-between sm:hidden">
                                    <Link
                                        v-if="series.prev_page_url"
                                        :href="series.prev_page_url"
                                        class="relative inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50"
                                    >
                                        Previous
                                    </Link>
                                    <Link
                                        v-if="series.next_page_url"
                                        :href="series.next_page_url"
                                        class="ml-3 relative inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50"
                                    >
                                        Next
                                    </Link>
                                </div>
                                <div class="hidden sm:flex-1 sm:flex sm:items-center sm:justify-between">
                                    <div>
                                        <p class="text-sm text-gray-700">
                                            Showing
                                            <span class="font-medium">{{ series.from }}</span>
                                            to
                                            <span class="font-medium">{{ series.to }}</span>
                                            of
                                            <span class="font-medium">{{ series.total }}</span>
                                            results
                                        </p>
                                    </div>
                                    <div>
                                        <nav class="relative z-0 inline-flex rounded-md shadow-sm -space-x-px" aria-label="Pagination">
                                            <Link
                                                v-if="series.prev_page_url"
                                                :href="series.prev_page_url"
                                                class="relative inline-flex items-center px-2 py-2 rounded-l-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50"
                                            >
                                                <span class="sr-only">Previous</span>
                                                <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                                                    <path fill-rule="evenodd" d="M12.707 5.293a1 1 0 010 1.414L9.414 10l3.293 3.293a1 1 0 01-1.414 1.414l-4-4a1 1 0 010-1.414l4-4a1 1 0 011.414 0z" clip-rule="evenodd" />
                                                </svg>
                                            </Link>

                                            <template v-for="(link, i) in series.links.slice(1, -1)" :key="i">
                                                <Link
                                                    :href="link.url"
                                                    :class="[
                                                        link.active
                                                            ? 'z-10 bg-primary-50 border-primary-500 text-primary-600'
                                                            : 'bg-white border-gray-300 text-gray-500 hover:bg-gray-50',
                                                        'relative inline-flex items-center px-4 py-2 border text-sm font-medium'
                                                    ]"
                                                >
                                                    {{ link.label }}
                                                </Link>
                                            </template>

                                            <Link
                                                v-if="series.next_page_url"
                                                :href="series.next_page_url"
                                                class="relative inline-flex items-center px-2 py-2 rounded-r-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50"
                                            >
                                                <span class="sr-only">Next</span>
                                                <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                                                    <path fill-rule="evenodd" d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z" clip-rule="evenodd" />
                                                </svg>
                                            </Link>
                                        </nav>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </AppLayout>
</template>